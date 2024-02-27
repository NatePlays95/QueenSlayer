extends CanvasLayer


func play():
	$AnimationPlayer.play("go")
	$AnimationPlayer.queue("RESET")
