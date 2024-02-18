extends Enemy

@export var DISTANCE_TO_APPROACH: float = 600
@export var DISTANCE_TO_ESCAPE: float = 150

@export var APPROACH_SPEED: float = 200
@export var ESCAPE_SPEED: float = 800

@export var AIM_DURATION: float = 2.0
@export var RELOAD_DURATION: float = 1.0

@export_category("Node References")
@export var SPRITE : AnimatedSprite2D

var projectile_packed: PackedScene = preload("res://scenes/enemies/crossbow_projectile.tscn")

enum States {
	RELOAD, AIM, SHOOT
}
var state: States = States.RELOAD
var state_timer: float = 0

var reload_timer = 0
var is_escaping := false

func spawn():
	# play spawn animation
	# find player
	find_player()


func shoot():
	var projectile : Hitbox = projectile_packed.instantiate()
	var params = { "parent": self }
	projectile.set_parameters(params)
	var direction = (player.global_position - global_position).normalized()
	projectile.set_direction(direction)
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position


func enter_state(new_state):
	state = new_state
	state_timer = 0
	match state:
		States.SHOOT:
			shoot()
			#reload_timer = RELOAD_DURATION


func process_state(delta):
	state_timer += delta
	match state:
		States.AIM:
			# else, do movement.
			var distance_vector = player.global_position - global_position
			var length = distance_vector.length()
			if is_escaping and length > DISTANCE_TO_APPROACH:
				is_escaping = false
			elif (not is_escaping) and length < DISTANCE_TO_ESCAPE:
				is_escaping = true
			
			if is_escaping:
				velocity = -1 * distance_vector.normalized() * ESCAPE_SPEED
			else:
				velocity = distance_vector.normalized() * APPROACH_SPEED
			move_and_slide()
			if state_timer > AIM_DURATION:
				enter_state(States.SHOOT)
		States.SHOOT:
			if state_timer > 0.1:
				enter_state(States.RELOAD)
		States.RELOAD:
			if state_timer > RELOAD_DURATION:
				enter_state(States.AIM)

func refresh_flip() -> void:
	$SpriteOrigin.scale.x = flip

func check_for_flip():
	if player.global_position.x > global_position.x:
		set_flip(Flip.RIGHT)
	else:
		set_flip(Flip.LEFT)

func _physics_process(delta):
	if hitstun_timer > 0: 
		_process_hitstun(delta)
		return
	if health <= 0: return
	
	if not player:
		find_player()
		return
	
	check_for_flip()
	process_state(delta)
