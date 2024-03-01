extends Node2D

func _ready():
	Fade.fade_in()
	AudioManager.play_music("Fase2.ogg")
	#$CombatWaveGroup.finished.connect(_on_all_waves_finished)
	#$CombatWaveGroup.start_wave()


func _on_queen_killed():
	AudioManager.stop_music()
	Engine.time_scale = 0.5
	await get_tree().create_timer(8.0, true, true, true).timeout
	Fade.fade_out()
	await Fade.fade_finished
	get_tree().change_scene_to_file("res://scenes/menus/end_scene.tscn")
