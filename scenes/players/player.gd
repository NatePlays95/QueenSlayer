class_name Player
extends CombatEntity



## Use a Sprite2D or AnimatedSprite2D
@export var CAMERA: Camera2D
@export var SPRITE: Node2D
@export var anim_player: AnimationPlayer
@export var anim_tree: AnimationTree
@export var audio_handler: PlayerAudioEventHandler

var attack_slash_packed: PackedScene = load("res://scenes/players/attacks/sword_slash.tscn")

const SPEED = 600.0
const JUMP_VELOCITY = -400.0

var immunity_timer: float = 0.0


func refresh_flip():
	#sprite.flip_h = true if flip == Flip.LEFT else false
	$SpriteOrigin.scale.x = flip
	#SPRITE.flip_h = flip == Flip.LEFT


func attack():
	var direction = (get_global_mouse_position() - global_position).normalized()
	var slash := attack_slash_packed.instantiate()
	slash.set_direction(direction)
	slash.parent = self
	#get_tree().root.add_child(slash)
	self.add_child(slash)
	slash.global_position = global_position
	anim_tree["parameters/OneShotAttack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	audio_handler.audio_event_handle("attack")
	$AttackTimer.start()

## can't be damage under immunity frames
func apply_damage(damage):
	if immunity_timer > 0: return
	super.apply_damage(damage)
	CameraManager.shake_camera(10)
	immunity_timer = 0.4
	audio_handler.audio_event_handle("hurt")

## can't receive hitstun under immunity frames
func apply_knockback(time_in, velocity_in):
	if immunity_timer > 0: return
	super.apply_knockback(time_in, velocity_in)


func footstep():
	$FootstepTimer.start()
	audio_handler.audio_event_handle("step")


func on_killed():
	# play anim
	anim_tree["parameters/OneShotDead/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	anim_tree["parameters/BlendWalking/blend_amount"] = 0
	audio_handler.audio_event_handle("death")
	Engine.time_scale = 0.2
	await get_tree().create_timer(2.0, false, false, true).timeout
	Engine.time_scale = 1.0
	Fade.fade_out()
	await Fade.fade_finished
	# go to title
	#get_tree().change_scene_to_file("res://scenes/menus/title.tscn")
	#get_tree().quit()
	get_tree().reload_current_scene()



func check_mouse_position():
	var new_flip
	if get_global_mouse_position().x > global_position.x:
		new_flip = Flip.RIGHT
	else:
		new_flip = Flip.LEFT
	if new_flip != flip:
		set_flip(new_flip)


func _ready():
	#motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	add_to_group("PLAYER")
	killed.connect(on_killed)


func _physics_process(delta):
	immunity_timer -= delta
	if hitstun_timer > 0: 
		_process_hitstun(delta)
		return
	if health <= 0: return
	
	check_mouse_position()
	
	if Input.is_action_just_pressed("attack1") and $AttackTimer.is_stopped():
		attack()
	
	var input_direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	if input_direction != Vector2.ZERO:
		input_direction = input_direction.normalized()
	
	#velocity = input_direction * SPEED
	if input_direction:
		velocity = velocity.move_toward(input_direction * SPEED, 5000 * delta)
		anim_tree["parameters/BlendWalking/blend_amount"] = 1
		#velocity = input_direction*SPEED
		if $FootstepTimer.is_stopped():
			footstep()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 2000 * delta)
		var blend_walking = anim_tree["parameters/BlendWalking/blend_amount"]
		anim_tree["parameters/BlendWalking/blend_amount"] = move_toward(blend_walking, 0, 5*delta)
		#velocity = Vector2.ZERO
	
	move_and_slide()
	
	CAMERA.global_position = CAMERA.global_position.move_toward(global_position, delta*10)
	#if (get_last_slide_collision()):
	#	velocity = Vector2.ZERO
	
