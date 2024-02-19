extends Node2D


func _ready():
	$CombatWaveGroup.finished.connect(_on_all_waves_finished)
	$CombatWaveGroup.start_wave()


func _on_all_waves_finished():
	print("Battle End!")
