class_name Hitbox
extends Area2D

signal combat_entity_hit(entity:CombatEntity)

# movement
@export var SPEED: float = 200.0
@export var DRAG: float = 0.95

# impact
@export var DAMAGE: float = 1


var parent: Node2D

var velocity: Vector2 = Vector2.ZERO

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
	
	if params.has("damage"): DAMAGE = params.damage
	##

func delete():
	queue_free()

func _physics_process(delta):
	velocity *= DRAG
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if parent is Player and body is Enemy:
		var enemy = body as Enemy
		enemy.apply_damage(DAMAGE)
		enemy.hitstun_timer = 0.2
		enemy.velocity = Vector2.from_angle(global_rotation) * 50
		combat_entity_hit.emit(enemy)
		pass
	if parent is Enemy and body is Player:
		var player = body as Player
		player.apply_damage(DAMAGE)
		combat_entity_hit.emit(player)
		pass
	pass
