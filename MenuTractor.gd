extends Area2D

signal screen_exited

export var velocity = Vector2(300.0, 0.0)
var is_moving = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_moving:
		position += velocity * delta


func start_moving():
	is_moving = true


func reset():
	is_moving = false
	position = Vector2.ZERO
	$AnimatedSprite.play()
	show()


func _on_VisibilityNotifier2D_screen_exited():
	is_moving = false
	$AnimatedSprite.stop()
	hide()
	emit_signal("screen_exited")
