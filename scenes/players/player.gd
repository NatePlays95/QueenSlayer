class_name Player
extends CombatEntity



## Use a Sprite2D or AnimatedSprite2D
@export var sprite: Node2D
@export var anim_player: AnimationPlayer

var attack_slash_packed: PackedScene = load("res://scenes/players/attacks/sword_slash.tscn")

const SPEED = 600.0
const JUMP_VELOCITY = -400.0

var immunity_timer: float = 0.0


func refresh_flip():
	#sprite.flip_h = true if flip == Flip.LEFT else false
	sprite.flip_h = flip == Flip.LEFT


func attack():
	var direction = (get_global_mouse_position() - global_position).normalized()
	var slash := attack_slash_packed.instantiate()
	slash.set_direction(direction)
	slash.parent = self
	#get_tree().root.add_child(slash)
	self.add_child(slash)
	slash.global_position = global_position

	$AttackTimer.start()

## can't be damage under immunity frames
func apply_damage(damage):
	if immunity_timer > 0: return
	super.apply_damage(damage)
	CameraManager.shake_camera(10)
	immunity_timer = 1.0


func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	add_to_group("PLAYER")


func _physics_process(delta):
	immunity_timer -= delta
	
	if Input.is_action_just_pressed("attack1") and $AttackTimer.is_stopped():
		attack()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	if input_direction != Vector2.ZERO:
		input_direction = input_direction.normalized()
	
	#velocity = input_direction * SPEED
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * SPEED, 5000 * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 2000 * delta)
	
	move_and_slide()
