class_name Room
extends Node2D

@onready var doors = $Doors
@onready var waves_group = $CombatWaveGroup



func _ready():
	waves_group.finished.connect(on_all_waves_finished)
	waves_group.start_wave()


func on_all_waves_finished():
	# placeholder behavior for deleting doors
	for child in doors.get_children():
		child.queue_free()
