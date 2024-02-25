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
	const STEPS_PATH = "Player/Steps/"
	const NUM_STEPS = 5
	
	var step: String = _random_sound_pick(STEPS_PATH, "Steps", NUM_STEPS)
	AudioManager.play_sfx(step)

func _attack_sound_play() -> void:
	const ATTACK_PATH = "Player/Attack/"
	const NUM_SWOOSHES = 3
	const NUM_VOICES = 4
	
	var voice: String = _random_sound_pick(ATTACK_PATH + "Voice/", "Voice", NUM_VOICES)
	var swoosh: String = _random_sound_pick(ATTACK_PATH + "Swoosh/", "Swoosh", NUM_SWOOSHES)   
	
	if randf() <= voice_trigger_chance * 0.01:
		AudioManager.play_sfx(voice)
	
	AudioManager.play_sfx(swoosh)

func _hurt_sound_play() -> void:
	pass

func _death_sound_play() -> void:
	const DEATH_SOUND_PATH = "Player/Death/"
	const NUM_DEATH_SOUNDS = 2
	
	var death: String = _random_sound_pick(DEATH_SOUND_PATH, "Death", NUM_DEATH_SOUNDS)
	AudioManager.play_sfx(death)
