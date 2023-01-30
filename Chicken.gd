extends "Mob.gd"

export var score = 100
export var damage = 0
export var speed = 100
export var type = "chicken"


func _init().(score, damage, speed, type):
	pass


func _on_VisibilityNotifier2D_screen_exited():
	die()


func idle():
	$AnimatedSprite.play("idle")


func run():
	$AnimatedSprite.play("run")
