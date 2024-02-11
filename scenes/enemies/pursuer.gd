extends Enemy


var MOVE_SPEED = 300

var attack_timer: float = 0

var slash_packed: PackedScene = load("res://scenes/enemies/enemy_slash1.tscn")

func attack():
	var slash = slash_packed.instantiate()
	
	var params = { parent = self }
	slash.set_parameters(params)
	
	var direction = (player.global_position - global_position).normalized()
	slash.set_direction(direction)
	
	#get_tree().root.add_child(slash)
	add_child(slash)
	slash.global_position = global_position + direction * 16
	
	attack_timer += 1.0


func _physics_process(delta):
	if hitstun_timer > 0: 
		_process_hitstun(delta)
		return
	if health <= 0: return
	
	if not player: return
	
	var vector_to_player = player.global_position - global_position
	var target_velocity = vector_to_player.normalized() * MOVE_SPEED
	velocity = velocity.move_toward(target_velocity, 800 * delta)
	move_and_slide()
	
	## make attack if close enough
	if attack_timer > 0:
		attack_timer -= delta
	else:
		if (vector_to_player).length() <= 100:
			attack()
