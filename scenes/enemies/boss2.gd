extends Enemy


@export var RUSH_SPEED := 2000.0
@export var JUMP_DURATION := 0.8

@export var SPRITE : AnimatedSprite2D

@export var COLLISION_SHAPE : CollisionShape2D

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
	find_player()


func attack_rush():
	rush_hitbox = rush_hitbox_packed.instantiate()
	var params = {"parent":self}
	rush_hitbox.set_parameters(params)
	add_child(rush_hitbox)
	var direction = (target_position - global_position).normalized()
	rush_hitbox.set_direction(direction)
	#rush_hitbox.global_position += direction * 64 # pushes hitbox 64 units forwards


func attack_punch():
	# TODO: replace rush hitbox with new hitbox
	punch_hitbox = rush_hitbox_packed.instantiate()
	var params = {"parent":self, "damage":1, "lifespan":0.2}
	punch_hitbox.set_parameters(params)
	add_child(punch_hitbox)
	var direction = (target_position - global_position).normalized()
	punch_hitbox.set_direction(direction)


func attack_jump():
	# no need for refs to jump hitbox
	var jump_hitbox = jump_hitbox_packed.instantiate()
	var params = {"parent":self}
	jump_hitbox.set_parameters(params)
	add_child(jump_hitbox)
	jump_hitbox.global_position = self.global_position



func enter_state(new_state):
	state = new_state
	state_timer = 0
	match state:
		States.INTRO:
			# play intro animation
			pass
		
		States.RUSH:
			rush_hitbox = null
			# play animation rush windup
			# find player position
			var direction = (player.global_position - global_position).normalized()
			target_position = player.global_position + direction*64
		
		States.AFTER_RUSH:
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
			pass
		
		States.JUMP:
			COLLISION_SHAPE.disabled = true
			target_position = player.global_position
			# set tweens
			var movement_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
			movement_tween.tween_property(self, "global_position", target_position, JUMP_DURATION)
			# TODO: might want to animate this instead
			#var jump_height = 1000
			#var current_height = SPRITE.position.y
			#var sprite_tween = create_tween().set_trans(Tween.TRANS_QUAD)
			#sprite_tween.tween_property(SPRITE, "position.y", current_height + jump_height, JUMP_DURATION*0.5)
			#sprite_tween.tween_property(SPRITE, "position.y", current_height, JUMP_DURATION*0.5)
		
		States.AFTER_JUMP:
			# create hitbox
			attack_jump()
			COLLISION_SHAPE.disabled = false
		
		States.DEFEATED:
			#if punch_hitbox:
			#	punch_hitbox.delete()
			pass


func process_state(delta):
	state_timer += delta
	match state:
		States.INTRO:
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
			if state_timer > 0.5:
				enter_state(States.PUNCH)
		
		States.PUNCH:
			global_position = global_position.lerp(target_position, 0.5)
			if punch_count >= 8:
				if state_timer >= 2:
					punch_count = 0
					enter_state(States.JUMP)
			else:
				if state_timer > 0.3:
					enter_state(States.PUNCH)
		
		States.BEFORE_JUMP:
			if state_timer > 0.5:
				enter_state(States.JUMP)
		
		States.JUMP:
			if state_timer > JUMP_DURATION:
				enter_state(States.AFTER_JUMP)
		
		States.AFTER_JUMP:
			if state_timer > 1.7:
				enter_state(States.RUSH)
		
		States.DEFEATED:
			if state_timer > 1.0:
				queue_free()


func _physics_process(delta):
	if hitstun_timer > 0: 
		_process_hitstun(delta)
		#return
	if health <= 0: return
	
	process_state(delta)


func _on_killed():
	enter_state(States.DEFEATED)
