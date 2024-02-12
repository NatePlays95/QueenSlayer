class_name Enemy
extends CombatEntity



var player: Player



func spawn():
	# play spawn animation
	# find player
	find_player()


func find_player() -> bool:
	player = get_tree().get_first_node_in_group("PLAYER")
	return player != null





func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	killed.connect(_on_killed)
	find_player()

# EXAMPLE
func _physics_process(delta):
	if hitstun_timer > 0: 
		_process_hitstun(delta)
		if not HAS_SUPER_ARMOR:
			return


func _on_killed():
	await get_tree().create_timer(0.5,false).timeout
	queue_free()
