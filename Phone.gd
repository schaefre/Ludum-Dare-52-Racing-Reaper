extends "Mob.gd"

export var score = 0
export var damage = 100
export var speed = 0
export var type = "phone"


func _init().(score, damage, speed, type):
	pass


func _on_VisibilityNotifier2D_screen_exited():
	die()
