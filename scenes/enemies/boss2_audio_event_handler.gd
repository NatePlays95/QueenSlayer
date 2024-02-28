class_name Boss2AudioEventHandler
extends AudioEventHandler

func audio_event_handle(event: String) -> void:
	match event:
		"punch":
			_punch_sound_play()
		"rush":
			_rush_sound_play()
		"jump":
			_jump_sound_play()
		"land":
			_land_sound_play()
		"hurt":
			_hurt_sound_play()
		"death":
			_death_sound_play()

func _punch_sound_play():
	var PUNCHES_PATH = "MuscleCat/Punch/"
	var NUM_PUNCHES = 5
	var NUM_SWOOSHES = 4
	
	_queue_random_sound(PUNCHES_PATH, "PunchVoice", NUM_PUNCHES)
	_queue_random_sound(PUNCHES_PATH, "PunchSwoosh", NUM_SWOOSHES)

func _rush_sound_play():
	AudioManager.play_sfx("MuscleCat/MuscleCatRush.wav")

func _jump_sound_play():
	AudioManager.play_sfx("MuscleCat/MuscleCatJump.wav")

func _land_sound_play():
	AudioManager.play_sfx("MuscleCat/MuscleCatLand.wav")

func _hurt_sound_play():
	var HURT_PATH = "Player/Hurt/"
	var NUM_HITS = 5
	
	_queue_random_sound(HURT_PATH + "Hit/", "Hit", NUM_HITS)

func _death_sound_play():
	AudioManager.play_sfx("MuscleCat/MuscleCatDeath.wav")
