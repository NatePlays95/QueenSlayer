class_name AudioEventHandler
extends Resource

func audio_event_handle(event: String) -> void:
	pass

func _random_sound_pick(path: String, sound_name: String, num_sounds: int) -> String:
	return path + sound_name + str(randi_range(1, num_sounds)) + ".wav"
