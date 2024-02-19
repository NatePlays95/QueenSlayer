extends Enemy

@export var SPRITE : Node2D
@export var ANIM_PLAYER : AnimationPlayer

var MOVE_SPEED = 300

var spawn_timer: float = 0
var attack_timer: float = 0

var slash_packed: PackedScene = load("res://scenes/enemies/enemy_slash1.tscn")

func spawn():
	ANIM_PLAYER.play("spawn")
	set_flip([-1,1].pick_random())
	spawn_timer = 0.5
	super()

func attack():
	attack_timer += 1.0
	ANIM_PLAYER.play("attack")
	await get_tree().create_timer(0.1, false).timeout
	
	var slash = slash_packed.instantiate()
	var params = { parent = self }
	slash.set_parameters(params)
	var direction = (player.global_position - global_position).normalized()
	slash.set_direction(direction)
	#get_tree().root.add_child(slash)
	add_child(slash)
	slash.global_position = global_position + direction * 16


func refresh_flip() -> void:
	$SpriteOrigin.scale.x = flip*abs($SpriteOrigin.scale.x)


func check_for_flip():
	if velocity.x > 0:
		set_flip(Flip.RIGHT)
	elif velocity.x < 0:
		set_flip(Flip.LEFT)


func _physics_process(delta):
	if hitstun_timer > 0: 
		_process_hitstun(delta)
		return
	if health <= 0: return
	
	if not player: 
		find_player()
		return
	
	spawn_timer -= delta
	if spawn_timer > 0: return
	
	check_for_flip()
	
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
