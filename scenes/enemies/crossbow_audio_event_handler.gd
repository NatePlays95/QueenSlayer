class_name CrossbowAudioEventHandler
extends AudioEventHandler


func audio_event_handle(event: String) -> void:
	match event:
		"reload":
			pass
		"shoot":
			pass
		"flee":
			pass
		"hurt":
			_hurt_sound_play()

#func __sound_play():

func _reload_sound_play():
	pass

func _shoot_sound_play():
	pass

func _flee_sound_play():
	pass

func _hurt_sound_play():
	_slash_sound_play()
