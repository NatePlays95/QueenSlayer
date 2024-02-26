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

func _punch_sound_play():
	const PUNCHES_PATH = "MuscleCat/Punch/"
	const NUM_PUNCHES = 5
	
	var punch: String = _random_sound_pick(PUNCHES_PATH, "PunchVoice", NUM_PUNCHES)
	AudioManager.play_sfx(punch)

func _rush_sound_play():
	AudioManager.play_sfx("MuscleCat/MuscleCatRush.wav")

func _jump_sound_play():
	AudioManager.play_sfx("MuscleCat/MuscleCatJump.wav")

func _land_sound_play():
	AudioManager.play_sfx("MuscleCat/MuscleCatLand.wav")
