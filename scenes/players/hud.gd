extends CanvasLayer

## cada queijo vale 4 HP.

@onready var player : Player = get_parent()

func _ready():
	player.health_changed.connect(_on_player_health_changed)
	%HealthBarBack.size.x = player.max_health * 64
	_on_player_health_changed(player.max_health)

func _on_player_health_changed(new_value:int):
	var health = clamp(new_value, 0, player.max_health)
	%HealthBarFront.size.x = health * 64
