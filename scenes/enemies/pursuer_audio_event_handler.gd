class_name PursuerAudioEventHandler
extends AudioEventHandler

func audio_event_handle(event: String) -> void:
	match event:
		"hurt":
			_hurt_sound_play()
		"attack":
			_attack_sound_play()


func _hurt_sound_play():
	_slash_sound_play()

func _attack_sound_play():
	var SOUND_PATH = "/Pursuer/Attack/"
	var NUM_SOUNDS = 2
	
	_queue_random_sound(SOUND_PATH, "Attack", NUM_SOUNDS)
