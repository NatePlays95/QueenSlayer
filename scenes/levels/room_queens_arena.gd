extends Room

@export var QUEEN: Node

func on_room_entered(p:Player):
	player = p
	add_child.call_deferred(doors) # locks all entrances
	room_area.queue_free()
	#waves_group.start_wave()
	QUEEN.spawn()
