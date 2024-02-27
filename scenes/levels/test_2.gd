extends Node2D


func _ready():
	Fade.fade_in()
	AudioManager.play_music("Fase1.ogg")
	#$CombatWaveGroup.finished.connect(_on_all_waves_finished)
	#$CombatWaveGroup.start_wave()


func _on_all_waves_finished():
	print("Battle End!")

func _on_boss_defeated():
	Fade.fade_out()
	await Fade.fade_finished
	get_tree().change_scene_to_file("res://scenes/levels/test_2.tscn")
