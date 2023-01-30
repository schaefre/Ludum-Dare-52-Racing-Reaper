extends "Mob.gd"

export var score = 0
export var damage = 10
export var speed = 0
export var type = "pitchfork"


func _init().(score, damage, speed, type):
	pass


func _on_VisibilityNotifier2D_screen_exited():
	die()
