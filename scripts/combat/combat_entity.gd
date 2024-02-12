class_name CombatEntity
extends CharacterBody2D

signal health_changed(new_value:int)
signal damage_taken
signal killed

@export var max_health: int = 10
@onready var health: int = self.max_health :
	set(value):
		health = value
		health_changed.emit(value)

@export var HAS_SUPER_ARMOR: bool = false
var hitstun_timer := 0.0

enum Flip { LEFT = -1, RIGHT = 1 }
var flip: Flip = Flip.RIGHT

func set_flip(direction) -> void:
	if direction == 1:
		flip = Flip.RIGHT
	elif direction == -1:
		flip = Flip.LEFT
	refresh_flip()

## virtual
func refresh_flip() -> void:
	pass

func apply_damage(damage) -> void:
	if health <= 0: return
	health = clamp(health - damage, 0, max_health)
	damage_taken.emit()
	if health == 0:
		CameraManager.shake_camera(2)
		killed.emit()

func apply_knockback(time_in, velocity_in):
	if not HAS_SUPER_ARMOR:
		hitstun_timer = max(hitstun_timer, time_in)
		velocity = velocity_in
	else:
		# play sfx for armor?
		pass



func _process_hitstun(delta):
	hitstun_timer -= delta
	if not HAS_SUPER_ARMOR:
		velocity *= 0.95
		move_and_slide()
