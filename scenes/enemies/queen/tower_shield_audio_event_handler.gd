class_name TowerShieldAudioEventHandler
extends AudioEventHandler

func audio_event_handle(event: String) -> void:
	match event:
		"step":
			_step_sound_play()
		"hurt":
			_hurt_sound_play()
		"death":
			_death_sound_play()


func _step_sound_play():
	var SOUND_PATH = "/Shield/Steps/"
	var NUM_SOUNDS = 22
	
	_queue_random_sound(SOUND_PATH, "ShieldStep", NUM_SOUNDS)

func _hurt_sound_play():
	var SOUND_PATH = "/Shield/Hurt/"
	var NUM_HITS = 6
	
	_queue_random_sound(SOUND_PATH, "Hit", NUM_HITS)


func _death_sound_play():
	var SOUND_PATH = "/Shield/Hurt/"
	var NUM_VOICES = 6

	_queue_random_sound(SOUND_PATH, "Voice", NUM_VOICES)
	
