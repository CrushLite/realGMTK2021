extends Position2D

export (NodePath) var anchor2
var has_been_pushed = false
var rope_length = 300

func _physics_process(delta):
	var anchor2_node = get_node(anchor2)
	
	if global_position.distance_to(anchor2_node.global_position) >= rope_length:
		var push = (self.global_position - anchor2_node.global_position).normalized() * 2000*delta
		(anchor2_node.get_parent() as RigidBody2D).apply_impulse(Vector2(0,0), push)
		has_been_pushed = true
	elif global_position.distance_to(anchor2_node.global_position) < rope_length - 10 and has_been_pushed:
		var push = (self.global_position - anchor2_node.global_position).normalized() * -2000*delta 
		(anchor2_node.get_parent() as RigidBody2D).apply_impulse(Vector2(0,0), push)
		has_been_pushed = false
	
#	print(global_position.distance_to(anchor2_node.global_position))
	
	
	
