extends CanvasLayer




@onready var player : Player = get_parent()

func _ready():
	player.health_changed.connect(_on_player_health_changed)


func _on_player_health_changed(new_value:int):
	var health = clamp(new_value, 0, 10)
	%HealthBarFront.size.x = health * 128
