extends Enemy


@export var RUSH_SPEED = 2000

var rush_hitbox_packed = preload("res://scenes/enemies/boss1_rush_hitbox.tscn")

enum States {
	INTRO, RUSH, AFTER_RUSH, JUMP, AFTER_JUMP, DEFEATED
}
var state: States = States.INTRO

var state_timer: float = 0
var rush_count: int = 0

var target_position := Vector2.ZERO
var rush_hitbox: Hitbox = null


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


func enter_state(new_state):
	state = new_state
	state_timer = 0
	match state:
		States.INTRO:
			# play intro animation
			pass
		States.RUSH:
			rush_hitbox = null
			rush_count += 1
			# play animation rush windup
			# find player position
			target_position = player.global_position
		States.AFTER_RUSH:
			rush_hitbox.delete()
			rush_hitbox = null
		States.DEFEATED:
			rush_hitbox.delete()


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
			if rush_count >= 3:
				if state_timer > 3:
					rush_count = 0
					enter_state(States.RUSH)
					#enter_state(States.JUMP)
			else:
				if state_timer > 0.5:
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
