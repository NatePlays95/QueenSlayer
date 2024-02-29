extends Enemy

@export var PREPARE_DURATION: float = 1.35
@export var CHARGE_DISTANCE: float = 1200
@export var CHARGE_SPEED: float = 800

@export_category("Node References")
@export var SPRITE : AnimatedSprite2D
@export var ANIM_PLAYER : AnimationPlayer

@export_category("Audio Resource")
@export var audio_handler: TowerShieldAudioEventHandler

var charge_hitbox_packed: PackedScene = preload("res://scenes/enemies/queen/tower_shield_charge_hitbox.tscn")

enum States {
	INTRO, PREPARE, CHARGE
}
var state: States = States.INTRO
var state_timer: float = 0

var target_position := Vector2.ZERO
var charge_hitbox : Hitbox = null
var charge_timer_offset: float = 0

func spawn():
	#play spawn anim
	super()
	enter_state(States.INTRO)
	charge_timer_offset = randf()*0.5


func attack_charge():
	var direction = player.global_position - global_position
	target_position = global_position + direction*CHARGE_DISTANCE
	
	charge_hitbox = charge_hitbox_packed.instantiate()
	var params = {"parent":self, "lifespan":CHARGE_DISTANCE/CHARGE_SPEED}
	charge_hitbox.set_parameters(params)
	add_child(charge_hitbox)
	charge_hitbox.set_direction(direction)
	check_for_flip()
	charge_timer_offset = randf()*0.5


func enter_state(new_state):
	state = new_state
	state_timer = 0
	match state:
		States.INTRO:
			ANIM_PLAYER.play("spawn")
			#reload_timer = RELOAD_DURATION
		
		States.PREPARE:
			#if charge_hitbox != null and not charge_hitbox.is_queued_for_deletion():
				#charge_hitbox.queue_free()
			charge_hitbox = null
			ANIM_PLAYER.play("prepare")
		
		States.CHARGE:
			ANIM_PLAYER.play("charge")
			attack_charge()


func process_state(delta):
	state_timer += delta
	match state:
		States.INTRO:
			if state_timer > 1.0:
				enter_state(States.PREPARE)
		
		States.PREPARE:
			velocity = velocity.move_toward(Vector2.ZERO, delta*2000)
			move_and_slide()
			check_for_flip()
			if state_timer > PREPARE_DURATION + charge_timer_offset:
				enter_state(States.CHARGE)
		
		States.CHARGE:
			var current_target = global_position.move_toward(target_position, CHARGE_SPEED)
			velocity = current_target - global_position
			move_and_slide()
			if state_timer > 2.0 or current_target == target_position:
				enter_state(States.PREPARE)
			if $StepTimer.is_stopped():
				audio_handler.audio_event_handle("step")
				$StepTimer.start()


func refresh_flip() -> void:
	#SPRITE.scale.x = flip
	SPRITE.flip_h = true if flip == 1 else false

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
	
	process_state(delta)


func _on_killed():
	audio_handler.audio_event_handle("death")
	ANIM_PLAYER.play("dead")
	await get_tree().create_timer(0.5,false).timeout
	queue_free()


func _on_damage_taken():
	audio_handler.audio_event_handle("hurt")
	pass
