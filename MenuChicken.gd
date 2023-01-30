extends Area2D

export var velocity = Vector2(200.0, 0.0)
var is_moving = false


func _ready():
	$AnimatedSprite.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_moving:
		position += velocity * delta


func start_moving():
	is_moving = true
	$AnimatedSprite.play("run")


func reset():
	is_moving = false
	position = Vector2.ZERO
	$AnimatedSprite.play("idle")
	show()


func _on_VisibilityNotifier2D_screen_exited():
	is_moving = false
	$AnimatedSprite.stop()
	hide()
