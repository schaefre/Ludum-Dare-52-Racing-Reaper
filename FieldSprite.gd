extends Sprite

export var speed = 0
var texture_width

func _ready():
	texture_width = texture.get_size().x * scale.x

func _process(delta):
	position.x -= speed * delta
	if position.x < -texture_width:
		position.x += 2*texture_width - 4
