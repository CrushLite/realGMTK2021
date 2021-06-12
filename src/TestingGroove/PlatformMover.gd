extends Node2D

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var push = (get_global_mouse_position() - $platform1.position).normalized() * 200
		$platform1.apply_impulse(Vector2(0,0), push)
	
	if event.is_action_pressed("ui_accept"):
#		$Rope/CollisionShape2D.shape.extents.y -= 10
		$PinJoint2D1.position.y += 10
		$PinJoint2D2.position.y -= 10
		

