extends CanvasLayer

## cada queijo vale 2 HP.

@onready var player : Player = get_parent()

func _ready():
	%HealthBarFront.size.x = player.max_health * 128
	player.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(new_value:int):
	var health = clamp(new_value, 0, player.max_health)
	%HealthBarFront.size.x = health * 128
