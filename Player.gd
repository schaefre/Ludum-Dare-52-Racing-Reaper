extends Area2D

signal move_up
signal move_down
signal hit(mob)
signal die(mob_type)
signal full_health

const MAX_LIFE = 100
export var life = MAX_LIFE

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.stop()
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("move_up")):
		emit_signal("move_up")
	elif(Input.is_action_just_pressed("move_down")):
		emit_signal("move_down")


func start(pos):
	set_position(pos)
	$AnimatedSprite.play()
	show()


func set_position(pos):
	position = pos


func _on_Player_body_entered(body):
	emit_signal("hit", body)


func take_damage(damage, mob_type):
	life = clamp(life-damage, 0, MAX_LIFE)
	if(life <= 0):
		emit_signal("die", mob_type)


func heal(healing):
	life = clamp(life+healing, 0, MAX_LIFE)
	if(life >= MAX_LIFE):
		emit_signal("full_health")
