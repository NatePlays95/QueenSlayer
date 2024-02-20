class_name Hitbox
extends Area2D

signal combat_entity_hit(entity:CombatEntity)

enum Knockback {
	CENTER, DIRECTION
}

# movement
@export var SPEED: float = 200.0
@export var DRAG: float = 0.95

# impact
@export var DAMAGE: float = 1
@export var HITSTUN: float = 0.0

@export var KNOCKBACK_POWER: float = 0.0
@export var KNOCKBACK_TYPE := Knockback.DIRECTION

@export var LIFESPAN: float = 0.5

var parent: Node2D

var velocity: Vector2 = Vector2.ZERO
var lifetime: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.debug_color = Color(Color.ORANGE_RED, 0.4)
	body_entered.connect(_on_body_entered)

#var velocity: Vector2 = Vector2.ZERO
func set_direction(direction: Vector2):
	velocity = direction * SPEED
	rotation = direction.angle()

func set_parameters(params: Dictionary) -> void:
	if params.has("parent"): parent = params.parent
	
	if params.has("speed"): SPEED = params.speed
	if params.has("lifespan"): LIFESPAN = params.lifespan
	if params.has("damage"): DAMAGE = params.damage
	if params.has("hitstun"): HITSTUN = params.hitstun
	
	if params.has("knockback_power"): KNOCKBACK_POWER = params.knockback_power
	##

func delete():
	queue_free()

func calculate_knockback(target:CombatEntity):
	var knockback_velocity := Vector2.ZERO
	match KNOCKBACK_TYPE:
		Knockback.CENTER:
			knockback_velocity = target.global_position - global_position
			knockback_velocity = knockback_velocity.normalized() * KNOCKBACK_POWER
		
		Knockback.DIRECTION:
			knockback_velocity = Vector2.from_angle(global_rotation) * KNOCKBACK_POWER
	
	return knockback_velocity

func _physics_process(delta):
	velocity *= DRAG
	position += velocity * delta
	
	lifetime += delta
	if lifetime > LIFESPAN:
		delete()

func _on_body_entered(body: Node2D) -> void:
	if (parent is Player and body is Enemy) or (parent is Enemy and body is Player):
		var target = body as CombatEntity
		target.apply_knockback(HITSTUN, calculate_knockback(target))
		# knockback goes first because we add immunity frames on damage
		target.apply_damage(DAMAGE)
		
		#enemy.apply_hitstun(0.5, Vector2.from_angle(global_rotation) * 200)
		combat_entity_hit.emit(target)
		pass
	pass
