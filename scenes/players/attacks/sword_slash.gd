extends Hitbox

func _ready():
	super._ready()
	$AnimatedSprite2D.global_position.y -= 32
	combat_entity_hit.connect(_on_combat_entity_hit)

func _on_combat_entity_hit(target: CombatEntity):
	pass
