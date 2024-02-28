extends Node2D

func _ready():
	Fade.fade_in()
	AudioManager.play_music("Fase2.ogg")
	#$CombatWaveGroup.finished.connect(_on_all_waves_finished)
	#$CombatWaveGroup.start_wave()
