class_name Enemy
extends CombatEntity


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var player: Player

var hitstun_timer: float = 0.0

func find_player() -> bool:
	player = get_tree().get_first_node_in_group("PLAYER")
	return player != null


func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	find_player()


func _physics_process(delta):
	if hitstun_timer > 0: 
		_process_hitstun(delta)
		return


func _process_hitstun(delta):
	hitstun_timer -= delta
	velocity *= 0.95
	move_and_slide()
