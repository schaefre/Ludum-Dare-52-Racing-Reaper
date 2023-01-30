extends "Mob.gd"

export var score = 50
export var damage = 15
export var speed = -50
export var type = "scarecrow"


func _init().(score, damage, speed, type):
	pass


func _on_VisibilityNotifier2D_screen_exited():
	die()


func idle():
	$AnimatedSprite.play("idle")


func run():
	$AnimatedSprite.play("run")
