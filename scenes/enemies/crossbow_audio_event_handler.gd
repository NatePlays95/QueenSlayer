class_name CrossbowAudioEventHandler
extends AudioEventHandler



func audio_event_handle(event: String) -> void:
	match event:
		"reload":
			_reload_sound_play()
		"shoot":
			_shoot_sound_play()
		"flee":
			pass
		"hurt":
			_hurt_sound_play()

#func __sound_play():

func _reload_sound_play():
	var SOUND_PATH = "Crossbow/Reload/"
	var NUM_SOUNDS = 4
	
	_queue_random_sound(SOUND_PATH, "Reload", NUM_SOUNDS)


func _shoot_sound_play():
	var SOUND_PATH = "Crossbow/Shoot/"
	var NUM_SOUNDS = 4
	
	_queue_random_sound(SOUND_PATH, "Shoot", NUM_SOUNDS)


func _flee_sound_play():
	pass

func _hurt_sound_play():
	_slash_sound_play()
