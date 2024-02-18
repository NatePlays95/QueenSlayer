extends Hitbox

func _ready():
	super._ready()
	$AnimatedSprite2D.global_position.y -= 32
