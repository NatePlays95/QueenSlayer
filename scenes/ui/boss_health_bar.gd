@tool
extends CanvasLayer

@export var BOSS_NAME: String = "" :
	set(value):
		%NameLabel.text = value
		BOSS_NAME = value

@export var SMOOTH_MODE: bool = true
#@export var progress_bar: ProgressBar
var progress_bar: TextureProgressBar
var name_label: RichTextLabel
var entity: CombatEntity

var enabled: bool = false

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	entity = get_parent()
	progress_bar = %ProgressBar
	name_label = %NameLabel
	#progress_bar.scale
	await entity.ready
	progress_bar.max_value = entity.max_health
	progress_bar.value = 0 #entity.health
	#%NinePatchRect.position.y = 880 + 200
	name_label.visible_ratio = 0
	name_label.text = BOSS_NAME
	entity.health_changed.connect(_on_health_changed)
	entity.spawned.connect(_on_entity_spawned)

func _on_entity_spawned():
	# animate bar
	print("spawne!!!!!!!!!!!")
	var tween1 = create_tween()
	#tween.set_parallel(true)
	$MarginContainer.scale.x = 0
	tween1.tween_property($MarginContainer, "scale:x", 1, 0.2)
	#tween1.tween_property(%NinePatchRect, "size:x", 1664, 0.8)
	tween1.tween_interval(0.5)
	tween1.tween_property(name_label, "visible_ratio", 1, 1.0)
	var tween2 = create_tween()
	tween2.set_parallel(false)
	tween2.tween_interval(.7)
	tween2.tween_property(progress_bar, "value", %ProgressBar.max_value, 2.0)
	tween2.tween_property(self, "enabled", true, 0.1)

func _on_health_changed(new_value:int):
	if not enabled: return
	if SMOOTH_MODE: return
	progress_bar.value = new_value

func _process(delta):
	if enabled:
		if SMOOTH_MODE:
			progress_bar.value = lerpf(progress_bar.value, entity.health, 10 * delta)
