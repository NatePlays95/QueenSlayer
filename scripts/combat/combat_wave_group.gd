class_name CombatWaveGroup
extends Node2D

signal finished

var waves: Array[CombatWave] = []

var wave_index = 0

func begin():
	start_wave()

func start_wave():
	# delay before starting the next wave
	await get_tree().create_timer(2.0).timeout
	print_debug("Wave %d" % [wave_index])
	waves[wave_index].start()

func _ready():
	y_sort_enabled = true
	for child in get_children():
		if not child is CombatWave: return
		var wave = child as CombatWave
		waves.push_back(wave)
		wave.wave_finished.connect(_on_wave_finished)

func _on_wave_finished():
	wave_index += 1
	if wave_index < waves.size():
		start_wave()
	else:
		finished.emit()
