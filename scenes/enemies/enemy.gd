class_name Enemy
extends CombatEntity



@export var HAS_SUPER_ARMOR: bool = false

var player: Player

var hitstun_timer: float = 0.0


func spawn():
	# play spawn animation
	# find player
	find_player()


func find_player() -> bool:
	player = get_tree().get_first_node_in_group("PLAYER")
	return player != null


func apply_hitstun(time_in, velocity_in):
	if not HAS_SUPER_ARMOR:
		hitstun_timer = max(hitstun_timer, time_in)
		velocity = velocity_in
	else:
		# play sfx for armor?
		pass


func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	killed.connect(_on_killed)
	find_player()


func _physics_process(delta):
	if hitstun_timer > 0: 
		_process_hitstun(delta)
		return


func _process_hitstun(delta):
	hitstun_timer -= delta
	if not HAS_SUPER_ARMOR:
		velocity *= 0.95
		move_and_slide()


func _on_killed():
	await get_tree().create_timer(0.5,false).timeout
	queue_free()




