class_name AudioEventHandler
extends Resource

func audio_event_handle(event: String) -> void:
	pass

func _queue_random_sound(path: String, sound_name: String, num_sounds: int, audio_bus: String = "SFX"):
	var sound = path + sound_name + str(randi_range(1, num_sounds)) + ".wav"
	AudioManager.play_sfx(sound, audio_bus)


func _slash_sound_play():
	var SLASH_PATH = "Player/Attack/Slash/"
	var NUM_SLASHES = 4
	
	_queue_random_sound(SLASH_PATH, "Slash", NUM_SLASHES, "AttackHit")

