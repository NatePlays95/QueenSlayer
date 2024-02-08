extends Node2D

@export var hitbox: Hitbox

@export var SPEED := 2000.0

var velocity: Vector2 = Vector2.ZERO

func set_direction(direction: Vector2):
	velocity = direction * SPEED
	rotation = direction.angle()
	#print(velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity *= 0.9
	position += velocity * delta

func _on_timer_timeout():
	queue_free()
