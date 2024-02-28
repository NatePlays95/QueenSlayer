class_name Room
extends Node2D

@onready var room_area : Area2D = $RoomArea
@onready var doors = $Doors
@onready var waves_group = $CombatWaveGroup

var player : Player

func _ready():
	z_as_relative = false
	y_sort_enabled = true
	room_area.body_entered.connect(_on_body_entered)
	waves_group.finished.connect(on_all_waves_finished)
	
	remove_child(doors)
	#waves_group.start_wave()



func on_room_entered(p:Player):
	player = p
	add_child.call_deferred(doors) # locks all entrances
	AudioManager.play_sfx("Misc/GateClosing.wav")
	room_area.queue_free()
	waves_group.start_wave()


func on_all_waves_finished():
	# placeholder behavior for deleting doors
	for child in doors.get_children():
		child.queue_free()
	AudioManager.play_sfx("Misc/GateOpening.wav")
	print_debug("Finished room: ", name)

func _on_body_entered(body:Node2D):
	if not body is Player: return
	print_debug("Foom entered: ", name)
	on_room_entered(body as Player)
