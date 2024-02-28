extends Enemy

@export var PREPARE_DURATION: float = 1.35
@export var CHARGE_DISTANCE: float = 600
@export var CHARGE_SPEED: float = 400

@export_category("Node References")
@export var SPRITE : AnimatedSprite2D
@export var ANIM_PLAYER : AnimationPlayer

var charge_hitbox_packed: PackedScene = preload("res://scenes/enemies/queen/tower_shield_charge_hitbox.tscn")

enum States {
	INTRO, PREPARE, CHARGE
}
var state: States = States.INTRO
var state_timer: float = 0

var target_position := Vector2.ZERO
var charge_hitbox : Hitbox = null

func spawn():
	#play spawn anim
	super()
	enter_state(States.INTRO)


func attack_charge():
	var direction = player.global_position - global_position
	var target_position = global_position + direction*CHARGE_DISTANCE
	
	charge_hitbox = charge_hitbox_packed.instantiate()
	var params = {"parent":self, "lifespan":CHARGE_DISTANCE/CHARGE_SPEED}
	charge_hitbox.set_parameters(params)
	add_child(charge_hitbox)
	charge_hitbox.set_direction(direction)
	
	AudioManager.play_sfx("towershield_charge_forward.ogg")


func enter_state(new_state):
	state = new_state
	state_timer = 0
	match state:
		States.INTRO:
			ANIM_PLAYER.play("spawn")
			#reload_timer = RELOAD_DURATION
		
		States.PREPARE:
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
			velocity = velocity.move_toward(Vector2.ZERO, delta*200)
			move_and_slide()
			if state_timer > PREPARE_DURATION:
				enter_state(States.CHARGE)
		
		States.CHARGE:
			var current_target = global_position.move_toward(target_position, delta*CHARGE_SPEED)
			var velocity = current_target - global_position
			move_and_slide()
			if state_timer > 2.0 or current_target == target_position:
				enter_state(States.PREPARE)


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


func _on_killed():
	AudioManager.play_sfx("towershield_death.ogg")
	SPRITE.animation = "dead"
	await get_tree().create_timer(0.5,false).timeout
	queue_free()
