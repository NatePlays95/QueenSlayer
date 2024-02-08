extends Node2D

@export var SMOOTH_MODE: bool = true
#@export var progress_bar: ProgressBar
var progress_bar: ProgressBar
var entity: CombatEntity


func _ready() -> void:
	entity = get_parent()
	progress_bar = $ProgressBar
	await entity.ready
	progress_bar.max_value = entity.max_health
	progress_bar.value = entity.health
	entity.health_changed.connect(_on_health_changed)

func _on_health_changed(new_value:int):
	if SMOOTH_MODE: return
	progress_bar.value = new_value

func _process(delta):
	if SMOOTH_MODE:
		progress_bar.value = lerpf(progress_bar.value, entity.health, 5 * delta)
