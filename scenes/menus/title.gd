extends Control



func play_title_song():
	AudioManager.play_music("Menu.ogg")


func _on_btn_play_pressed():
	AudioManager.play_music("Fase1.ogg")
	get_tree().change_scene_to_file("res://scenes/levels/prototype/level_1.tscn")


func _on_btn_credits_pressed():
	$AnimationPlayer.play("credits")
	pass # Replace with function body.


func _on_btn_quit_pressed():
	get_tree().quit()



