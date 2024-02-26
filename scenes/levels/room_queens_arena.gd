extends Room

@export var QUEEN: Node

func _ready():
	z_as_relative = false
	y_sort_enabled = true
	room_area.body_entered.connect(_on_body_entered)
	#waves_group.finished.connect(on_all_waves_finished)
	
	remove_child(doors)

func on_room_entered(p:Player):
	player = p
	add_child.call_deferred(doors) # locks all entrances
	room_area.queue_free()
	#waves_group.start_wave()
	QUEEN.spawn()
