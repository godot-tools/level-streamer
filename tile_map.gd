extends Node2D

onready var ground = get_node("Ground")

func get_bounds():
	var width = 640 * scale.x
	var height = 480 * scale.y
	var x = position.x + width/2
	var y = position.y + height/2
	return Rect2(x, y, width, height)
