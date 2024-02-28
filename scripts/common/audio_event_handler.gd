class_name AudioEventHandler
extends Resource

func audio_event_handle(event: String) -> void:
	pass

func _random_sound_pick(path: String, sound_name: String, num_sounds: int) -> String:
	return path + sound_name + str(randi_range(1, num_sounds)) + ".wav"

func _slash_sound_play():
	const SLASH_PATH = "Player/Attack/Slash/"
	const NUM_SLASHES = 4
	
	var slash: String = _random_sound_pick(SLASH_PATH, "Slash", NUM_SLASHES)
	AudioManager.play_sfx(slash)
