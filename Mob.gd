extends RigidBody2D

signal die(mob)

var mob_score
var mob_damage
var mob_speed
var mob_type

func _init(score = 0, damage = 0, speed = 0, type = "mob").():
	mob_score = score
	mob_damage = damage
	mob_speed = speed
	mob_type = type

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_damage():
	return mob_damage


func get_score():
	return mob_score


func get_speed():
	return mob_speed


func get_type():
	return mob_type


func idle():
	print("idle mob")
	pass


func run():
	pass


func die():
	emit_signal("die", self)
	queue_free()
