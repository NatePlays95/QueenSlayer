extends Node



var trans_camera: Camera2D
var trans_tween: Tween



func get_current_camera() -> Camera2D:
	return get_tree().root.get_camera_2d()


func shake_camera(strength:float, camera: Camera2D=null):
	if camera == null:
		camera = get_current_camera()
	
	var shaker = camera.get_node_or_null("Camera2DShaker")
	if not shaker: return
	shaker.apply_random_shake(strength)


func transition_camera2d(from:Camera2D, to:Camera2D, duration:float, ease_mode:Tween.EaseType=Tween.EASE_IN_OUT) -> void:
	if trans_tween and trans_tween.is_running(): return
	# copy starting parameters
	trans_camera.zoom = from.zoom
	trans_camera.offset = from.offset
	trans_camera.light_mask = from.light_mask
	trans_camera.global_transform = from.global_transform
	# switch to transition
	trans_camera.enabled = true
	trans_camera.make_current()
	# setup tween
	if trans_tween: trans_tween.kill() # invalidates tween to be cleaned by garbage collector
	trans_tween = create_tween() # makes a new one :)
	trans_tween.set_ease(ease_mode)
	trans_tween.set_trans(Tween.TRANS_CUBIC)
	trans_tween.set_parallel(true)
	trans_tween.tween_property(trans_camera, "global_transform", 
			to.global_transform, duration)
	trans_tween.tween_property(trans_camera, "zoom", 
			to.zoom, duration)
	trans_tween.tween_property(trans_camera, "offset", 
			to.offset, duration)
	#trans_tween.start()
	# wait
	await trans_tween.finished
	# make second camera current
	to.enabled = true
	to.make_current()
	trans_camera.enabled = false





func _ready():
	_setup_trans_camera()

func _setup_trans_camera():
	trans_camera = Camera2D.new()
	trans_camera.enabled = false
	add_child(trans_camera)
	#trans_tween = create_tween()
