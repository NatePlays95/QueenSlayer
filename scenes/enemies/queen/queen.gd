extends Enemy

@export var PRE_JUMP_DURATION := 0.5
@export var JUMP_DURATION := 0.8
@export var SWIPE_DISTANCE : float = 500
@export var SWIPE_DURATION : float = 0.3

@export_category("Node References")
@export var COLLISION_SHAPE: CollisionShape2D
@export var SPRITE: AnimatedSprite2D
@export var SPRITE_ORIGIN: Node2D
@export var ANIM_PLAYER: AnimationPlayer
@export var MARKER_ARENA: Marker2D
@export var MARKER_THRONE: Marker2D

var swipe_hitbox_packed: PackedScene = load("res://scenes/enemies/queen/queen_swipe_hitbox.tscn")

# CombatWave types.
var wave_1_packed: PackedScene = load("res://scenes/levels/queen_wave1.tscn")
var wave_2_packed: PackedScene = load("res://scenes/levels/queen_wave2.tscn")#null#load(


enum States {
	NONE,
	INTRO, JUMP_TO_ARENA, JUMP_TO_THRONE,
	LAND_ON_ARENA, SWIPE_ATTACK, AFTER_SWIPES,
	LAND_ON_THRONE, WAVE_1, WAVE_2, AFTER_WAVES
}
var state: States = States.NONE
var state_timer: float = 0.0

var player_hits_while_in_arena: int = 0
var swipe_target_position: Vector2 = Vector2.ZERO
var swipe_count: int = 0
var swipe_hitbox: Hitbox = null



func spawn():
	# play spawn animation
	# find player
	find_player()
	spawned.emit()
	$BossHealthBar.visible = true
	enter_state(States.INTRO)


func attack_swipe():
	swipe_count += 1
	
	swipe_hitbox = swipe_hitbox_packed.instantiate()
	var params = {"parent":self}
	swipe_hitbox.set_parameters(params)
	add_child(swipe_hitbox)
	swipe_hitbox.set_direction(swipe_target_position - global_position)
	#ANIM_PLAYER.play("RESET")
	#ANIM_PLAYER.queue("swipe")
	check_for_flip()
	#AudioManager.play_sfx("queen_swipe.ogg")
	ANIM_PLAYER.play("swipe")
	pass


func aim_swipe():
	var direction = (player.global_position - global_position).normalized()
	swipe_target_position = global_position + direction * SWIPE_DISTANCE


func jump_to_position(target_position):
	#SPRITE.play("squat")
	await get_tree().create_timer(PRE_JUMP_DURATION, false, true).timeout
	if health <= 0: return
	COLLISION_SHAPE.disabled = true
	#SPRITE.play("jump")
	# set tweens
	var movement_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	movement_tween.tween_property(self, "global_position", target_position, JUMP_DURATION)
	movement_tween.tween_property(COLLISION_SHAPE, "disabled", false, 0.01)
	# TODO: might want to animate this instead
	var jump_height = 500
	var current_height = 0#SPRITE.position.y
	var sprite_tween = create_tween().set_trans(Tween.TRANS_QUAD)
	sprite_tween.tween_callback(SPRITE.play.bind("jump"))
	sprite_tween.set_ease(Tween.EASE_OUT)
	sprite_tween.tween_property(SPRITE_ORIGIN, "position:y", current_height - jump_height, JUMP_DURATION*0.5)
	sprite_tween.tween_callback(SPRITE.play.bind("land"))
	sprite_tween.set_ease(Tween.EASE_IN)
	sprite_tween.tween_property(SPRITE_ORIGIN, "position:y", current_height, JUMP_DURATION*0.5)




func enter_state(new_state):
	state = new_state
	state_timer = 0.0
	match state:
		States.INTRO:
			set_flip(Flip.LEFT)
			# play intro anim
			CameraManager.transition_camera2d(CameraManager.get_current_camera(), $Camera2D, 0.6)
		
		States.JUMP_TO_ARENA:
			set_flip(Flip.LEFT)
			jump_to_position(MARKER_ARENA.global_position)
		
		States.JUMP_TO_THRONE:
			set_flip(Flip.RIGHT)
			jump_to_position(MARKER_THRONE.global_position)
		
		States.SWIPE_ATTACK:
			aim_swipe()
			#SPRITE.play("prepare")
			pass
		
		States.WAVE_1:
			var wave_1 : CombatWave = wave_1_packed.instantiate()
			get_parent().add_child(wave_1)
			wave_1.wave_finished.connect(_on_wave_finished.bind(wave_1))
			wave_1.start()
			pass
		
		States.WAVE_2:
			var wave_2 : CombatWave = wave_2_packed.instantiate()
			get_parent().add_child(wave_2)
			wave_2.wave_finished.connect(_on_wave_finished.bind(wave_2))
			wave_2.start()
			pass
		
		States.AFTER_WAVES:
			#play upset animation
			pass
		
		_:
			pass


func process_state(delta):
	state_timer += delta
	$LblStateName.text = States.keys()[state]
	$LblStateTimer.text = str(state_timer)
	match state:
		States.INTRO:
			if state_timer > 3.0:
				CameraManager.transition_camera2d(CameraManager.get_current_camera(), player.get_node("FollowCamera"), 0.2)
				enter_state(States.JUMP_TO_ARENA)
		
		States.JUMP_TO_ARENA:
			if state_timer > PRE_JUMP_DURATION+JUMP_DURATION+0.5:
				player_hits_while_in_arena = 0
				swipe_count = 0
				enter_state(States.SWIPE_ATTACK) 
		
		States.JUMP_TO_THRONE:
			if state_timer > PRE_JUMP_DURATION+JUMP_DURATION+0.5:
				set_flip(Flip.LEFT)
				if health > 0.5*max_health:
					enter_state(States.WAVE_1)
				else:
					enter_state(States.WAVE_2)
		
		States.SWIPE_ATTACK:
			# delay to start
			# if health is below 50% we make startup faster
			if (health > 0.5*max_health and state_timer > 0.2
					or health < 0.5*max_health and state_timer > 0.1):
				
				var swipe_speed = delta * SWIPE_DISTANCE / SWIPE_DURATION
				global_position = global_position.move_toward(swipe_target_position, swipe_speed)
				if swipe_hitbox == null and state_timer < 0.3:
					attack_swipe()
			
			# to next swipe
			if state_timer > 0.85:
				swipe_hitbox = null
				if swipe_count >= 5:
					enter_state(States.AFTER_SWIPES)
				else:
					enter_state(States.SWIPE_ATTACK)
		
		States.AFTER_SWIPES:
			if state_timer > 2.0:
				if player_hits_while_in_arena >= 6:
					player_hits_while_in_arena = 0
					enter_state(States.JUMP_TO_THRONE)
				else:
					swipe_count = 0
					enter_state(States.SWIPE_ATTACK)
		
		States.AFTER_WAVES:
			if state_timer > 2.0:
				enter_state(States.JUMP_TO_ARENA)
		
		_:
			pass


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
		#return
	if health <= 0: return
	
	process_state(delta)

func _on_damage_taken():
	#audio_handler.audio_event_handle("hurt")
	if state in [States.LAND_ON_ARENA, States.SWIPE_ATTACK, States.AFTER_SWIPES]:
		player_hits_while_in_arena += 1
	pass # Replace with function body.

func _on_wave_finished(wave_node: CombatWave):
	wave_node.queue_free()
	enter_state(States.AFTER_WAVES)
