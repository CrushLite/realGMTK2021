extends KinematicBody2D

# just a wrapper so we don't touch other code


signal win
signal drowned



func _on_Player_motion(motion):
	move_and_slide(motion)
	pass # Replace with function body.


func _on_Player_drowned():
	emit_signal("drowned")
	pass # Replace with function body.


func _on_Player_win():
	emit_signal("win")
	pass # Replace with function body.
