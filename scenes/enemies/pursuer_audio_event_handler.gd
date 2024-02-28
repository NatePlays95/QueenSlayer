class_name PursuerAudioEventHandler
extends AudioEventHandler

func audio_event_handle(event: String) -> void:
	match event:
		"hurt":
			_hurt_sound_play()


func _hurt_sound_play():
	_slash_sound_play()
