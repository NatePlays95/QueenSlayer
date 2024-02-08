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
