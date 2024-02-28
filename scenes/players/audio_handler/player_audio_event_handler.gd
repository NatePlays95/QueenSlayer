class_name PlayerAudioEventHandler
extends AudioEventHandler

@export_range(0.0, 100.0, 0.5) var voice_trigger_chance: float = 20.0

func audio_event_handle(event: String) -> void:
	match event:
		"step":
			_step_sound_play()
		"attack":
			_attack_sound_play()
		"hurt":
			_hurt_sound_play()
		"death":
			_death_sound_play()


func _step_sound_play() -> void:
	var STEPS_PATH = "Player/Steps/"
	var NUM_STEPS = 5
	
	_queue_random_sound(STEPS_PATH, "Steps", NUM_STEPS)


func _attack_sound_play() -> void:
	var ATTACK_PATH = "Player/Attack/"
	var NUM_SWOOSHES = 3
	var NUM_VOICES = 4
	
	_queue_random_sound(ATTACK_PATH + "Swoosh/", "Swoosh", NUM_SWOOSHES)   
	
	if randf() <= voice_trigger_chance * 0.01:
		_queue_random_sound(ATTACK_PATH + "Voice/", "Voice", NUM_VOICES)


func _hurt_sound_play() -> void:
	pass

func _death_sound_play() -> void:
	const DEATH_SOUND_PATH = "Player/Death/"
	const NUM_DEATH_SOUNDS = 2
	
	_queue_random_sound(DEATH_SOUND_PATH, "Death", NUM_DEATH_SOUNDS)