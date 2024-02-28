extends Enemy


@export var RUSH_SPEED := 2000.0
@export var JUMP_DURATION := 0.8

@export var SPRITE : AnimatedSprite2D
@export var ANIM_PLAYER : AnimationPlayer

@export var COLLISION_SHAPE : CollisionShape2D

@export var audio_handler : Boss2AudioEventHandler

var rush_hitbox_packed = preload("res://scenes/enemies/boss2_rush_hitbox.tscn")
var jump_hitbox_packed = preload("res://scenes/enemies/boss2_jump_hitbox.tscn")

enum States {
	INTRO, RUSH, AFTER_RUSH, PUNCH, BEFORE_JUMP, JUMP, AFTER_JUMP, DEFEATED
}
var state: States = States.INTRO

var state_timer: float = 0
var punch_count: int = 0

var target_position := Vector2.ZERO
var rush_hitbox: Hitbox = null
var punch_hitbox: Hitbox = null


func spawn():
	enter_state(States.INTRO)
	ANIM_PLAYER.play("spawn")
	super()


func apply_damage(damage) -> void:
	if state == States.INTRO: return
	super.apply_damage(damage)


func attack_rush():
	check_for_flip()
	rush_hitbox = rush_hitbox_packed.instantiate()
	var params = {
		"parent":self, "hitstun": 0.6, "knockback_power": 5000
	}
	rush_hitbox.set_parameters(params)
	add_child(rush_hitbox)
	var direction = (target_position - global_position).normalized()
	rush_hitbox.set_direction(direction)
	#rush_hitbox.global_position += direction * 64 # pushes hitbox 64 units forwards
	ANIM_PLAYER.play("rush2")
	audio_handler.audio_event_handle("rush")


func attack_punch():
	# TODO: replace rush hitbox with new hitbox
	punch_hitbox = rush_hitbox_packed.instantiate()
	var params = {"parent":self, "damage":1, "lifespan":0.2}
	punch_hitbox.set_parameters(params)
	add_child(punch_hitbox)
	var direction = (target_position - global_position).normalized()
	punch_hitbox.set_direction(direction)
	ANIM_PLAYER.play("RESET")
	ANIM_PLAYER.queue("punch")
	check_for_flip()
	audio_handler.audio_event_handle("punch")


func attack_jump():
	# no need for refs to jump hitbox
	var jump_hitbox = jump_hitbox_packed.instantiate()
	var params = {"parent":self}
	jump_hitbox.set_parameters(params)
	add_child(jump_hitbox)
	jump_hitbox.global_position = self.global_position
	audio_handler.audio_event_handle("land")
	



func enter_state(new_state):
	state = new_state
	state_timer = 0
	match state:
		States.INTRO:
			# play intro animation
			pass
		
		States.RUSH:
			SPRITE.animation = "prepare"
			rush_hitbox = null
			# play animation rush windup
			# find player position
			var direction = (player.global_position - global_position).normalized()
			target_position = player.global_position + direction*64
		
		States.AFTER_RUSH:
			#ANIM_PLAYER.play("rush_after")
			SPRITE.play("prepare")
			rush_hitbox.delete()
			rush_hitbox = null
		
		States.PUNCH:
			punch_hitbox = null
			punch_count += 1
			var direction = (player.global_position - global_position).normalized()
			target_position = global_position + direction * 125
			attack_punch()
		
		States.BEFORE_JUMP:
			#play squat animation
			SPRITE.animation = "squat"
			audio_handler.audio_event_handle("jump")
			pass
		
		States.JUMP:
			COLLISION_SHAPE.disabled = true
			target_position = player.global_position
			# set tweens
			var movement_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
			movement_tween.tween_property(self, "global_position", target_position, JUMP_DURATION)
			# TODO: might want to animate this instead
			var jump_height = 300
			var current_height = 0#SPRITE.position.y
			var sprite_tween = create_tween().set_trans(Tween.TRANS_QUAD)
			sprite_tween.tween_callback(SPRITE.play.bind("prepare"))
			sprite_tween.set_ease(Tween.EASE_OUT)
			sprite_tween.tween_property($SpriteOrigin, "position:y", current_height - jump_height, JUMP_DURATION*0.5)
			sprite_tween.tween_callback(SPRITE.play.bind("elbow"))
			sprite_tween.set_ease(Tween.EASE_IN)
			sprite_tween.tween_property($SpriteOrigin, "position:y", current_height, JUMP_DURATION*0.5)
		
		States.AFTER_JUMP:
			# create hitbox
			COLLISION_SHAPE.disabled = false
			SPRITE.play("land")
			attack_jump()
			


func process_state(delta):
	state_timer += delta
	match state:
		States.INTRO:
			check_for_flip()
			# INTRO DURATION
			if state_timer > 4.0: #seconds
				enter_state(States.RUSH)
		
		States.RUSH:
			# only move after half a second or so
			if state_timer >= 0.3:
				if rush_hitbox == null:
					attack_rush()
				global_position = global_position.move_toward(target_position, RUSH_SPEED*delta)
				if global_position == target_position:
					enter_state(States.AFTER_RUSH)
		
		States.AFTER_RUSH:
			check_for_flip()
			if state_timer > 1.0:
				enter_state(States.PUNCH)
		
		States.PUNCH:
			global_position = global_position.lerp(target_position, 0.5)
			if punch_count >= 8:
				if state_timer >= 2:
					punch_count = 0
					enter_state(States.BEFORE_JUMP)
			else:
				if state_timer > 0.3:
					enter_state(States.PUNCH)
		
		States.BEFORE_JUMP:
			check_for_flip()
			if state_timer > 0.2:
				enter_state(States.JUMP)
		
		States.JUMP:
			if state_timer > JUMP_DURATION:
				enter_state(States.AFTER_JUMP)
		
		States.AFTER_JUMP:
			if state_timer > 1.0:
				check_for_flip()
				SPRITE.animation = "prepare"
			if state_timer > 1.7:
				enter_state(States.RUSH)



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


func _on_killed():
	AudioManager.play_sfx("muscle_death.ogg")
	ANIM_PLAYER.play("dead")
	await get_tree().create_timer(1.0, false).timeout
	queue_free()


func _on_damage_taken():
	audio_handler.audio_event_handle("hurt")
	pass
