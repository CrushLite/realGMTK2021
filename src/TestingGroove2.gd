extends Node2D


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if $platform.mode == 0:
			$platform.mode = 3# RigidBody2D.MODE_KINEMATIC
		else:
			$platform.mode = 0
