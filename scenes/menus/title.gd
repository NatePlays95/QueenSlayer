extends Control


func _ready():
	Fade.fade_in(0.1)


func play_title_song():
	AudioManager.play_music("Menu.ogg", "MenuMusic")


func _on_btn_play_pressed():
	#AudioManager.play_music("Fase1.ogg")
	Fade.fade_out()
	await Fade.fade_finished
	get_tree().change_scene_to_file("res://scenes/levels/prototype/test_2.tscn")


func _on_btn_credits_pressed():
	$AnimationPlayer.play("credits")
	pass # Replace with function body.


func _on_btn_quit_pressed():
	get_tree().quit()



