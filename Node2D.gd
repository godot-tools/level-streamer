extends KinematicBody2D

export var speed = 10.0

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		move_and_collide(Vector2(-speed, 0))
	if Input.is_action_pressed("ui_right"):
		move_and_collide(Vector2(speed, 0))
	if Input.is_action_pressed("ui_up"):
		move_and_collide(Vector2(0, -speed))
	if Input.is_action_pressed("ui_down"):
		move_and_collide(Vector2(0, speed))
