extends Enemy

@export var JUMP_DURATION := 0.8

@export_category("Node References")
@export var COLLISION_SHAPE: CollisionShape2D
@export var SPRITE: AnimatedSprite2D
@export var SPRITE_ORIGIN: Node2D
@export var ANIM_PLAYER: AnimationPlayer
@export var MARKER_ARENA: Marker2D
@export var MARKER_THRONE: Marker2D

var swipe_hitbox_packed: PackedScene = load("res://scenes/enemies/boss2_rush_hitbox.tscn")

enum States {
	NONE,
	INTRO, JUMP_TO_ARENA, JUMP_TO_THRONE,
	LAND_ON_ARENA, SWIPE_ATTACK, AFTER_SWIPES,
	LAND_ON_THRONE, WAVE_1, WAVE_2,
}
var state: States = States.NONE
var state_timer: float = 0.0

var player_hits_while_in_arena: int = 0
var swipe_count: int = 0


func spawn():
	# play spawn animation
	# find player
	find_player()
	spawned.emit()
	enter_state(States.INTRO)


func attack_swipe():
	pass


func jump_to_position(target_position):
	#SPRITE.play("squat")
	await get_tree().create_timer(0.5, false, true)
	if health <= 0: return
	COLLISION_SHAPE.disabled = true
	#SPRITE.play("jump")
	# set tweens
	var movement_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	movement_tween.tween_property(self, "global_position", target_position, JUMP_DURATION)
	# TODO: might want to animate this instead
	var jump_height = 300
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
			CameraManager.transition_camera2d(CameraManager.get_current_camera(), $Camera2D, 0.6)
		
		States.SWIPE_ATTACK:
			swipe_count += 1
			attack_swipe()
			#SPRITE.play("prepare")
			pass
		
		_:
			pass


func process_state(delta):
	state_timer += delta
	match state:
		States.SWIPE_ATTACK:
			# to next swipe
			if state_timer > 0.85:
				if swipe_count >= 5:
					enter_state(States.SWIPE_ATTACK)
				else:
					enter_state(States.AFTER_SWIPES)
		
		States.AFTER_SWIPES:
			if state_timer > 2.0:
				if player_hits_while_in_arena >= 2:
					enter_state(States.JUMP_TO_THRONE)
		
		_:
			pass
