class_name QueenAudioEventHandler
extends AudioEventHandler

func audio_event_handle(event: String):
	match event:
		"attack":
			_attack_sound_play()
		"intro":
			_intro_sound_play()
		"hurt":
			_hurt_sound_play()
		"jump":
			_jump_sound_play()
		"death":
			_death_sound_play()
		"tired":
			_tired_sound_play()
		"summon":
			_summon_sound_play()


func _attack_sound_play():
	var SOUND_PATH = "/Queen/Attack/"
	var NUM_SWIPES = 4
	var NUM_VOICES = 7
	var voice_name = "AttackVoice"
	
	_queue_random_sound(SOUND_PATH, "Attack", NUM_SWIPES, "QueenAttack")
	if randf() <= 0.65:
		if randf() <= 0.2:
			voice_name = "CatVoice"
			NUM_VOICES = 3
		
		_queue_random_sound(SOUND_PATH, voice_name, NUM_VOICES, "QueenVoice")


func _intro_sound_play():
	AudioManager.play_sfx("/Queen/EvilLaugh.wav", "QueenVoice")

func _hurt_sound_play():
	var SOUND_PATH = "/Queen/Hurt/"
	var NUM_VOICES = 4
	
	var file_name = "Hurt"
	if randf() <= 0.2:
		file_name = "CatHurt"
		NUM_VOICES = 2
	
	if randf() <= 0.35:
		_queue_random_sound(SOUND_PATH, file_name, NUM_VOICES, "QueenVoice")
	_slash_sound_play()

func _jump_sound_play():
	AudioManager.play_sfx("/Queen/Jump.wav", "QueenVoice")
	AudioManager.play_sfx("/Queen/JumpSwoosh.wav", "Swooshes")

func _death_sound_play():
	AudioManager.play_sfx("/Queen/Death.wav")

func _tired_sound_play():
	AudioManager.play_sfx("/Queen/Tired.wav", "QueenTired")

func _summon_sound_play():
	AudioManager.play_sfx("/Queen/Summon.wav", "QueenSummon")
