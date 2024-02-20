extends Control


func _on_btn_play_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/prototype/level_1.tscn")


func _on_btn_credits_pressed():
	$AnimationPlayer.play("credits")
	pass # Replace with function body.


func _on_btn_quit_pressed():
	get_tree().quit()



