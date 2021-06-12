extends Position2D

# sets the length of the spring based on the distance 
#  to the other anchor
signal attached
export(NodePath) var anchor_target_path

func init():
	var anchor_target : Position2D = get_node(anchor_target_path)
	print("finding anchor target: ", anchor_target)
	$rope.length = global_position.distance_to(anchor_target.global_position)
	$rope.rest_length = $rope.length
#	$rope.rest_length = global_position.distance_to(anchor_target.global_position)
	print("New Length: ", $rope.length)
	
	#point the joint towards the target
#	$rope.global_rotation = 0
	var ang = $rope.get_angle_to(anchor_target.global_position)
	$rope.rotate(ang - PI/2)
	print(ang)
#	$rope.look_at(anchor_target.global_position)
	
	$rope.node_a = get_parent().get_path()
	$rope.node_b = anchor_target.get_parent().get_path()
	

func pull(amount):
	print("Rope being pulled %s -> %s" % [$rope.rest_length, $rope.rest_length-amount])
	$rope.rest_length -= amount
	if $rope.rest_length <= 0: 
		$rope.rest_length = -1

func _physics_process(delta):
	var anchor_target = get_node_or_null(anchor_target_path)
	if anchor_target:
		$Line2D.points[0] = Vector2(0,0)
		$Line2D.points[1] = anchor_target.global_position - global_position
#		rotation = 0
		global_rotation = 0
#		anchor_target.global_rotation = 0
	else:
		queue_free() # the anchor target is dead so we are dead


func launch_rope():
	var anchor_target = get_node_or_null(anchor_target_path)
	$Tween.interpolate_method(
			self,
			"update_point0",
			$Line2D.points[1],
			anchor_target.global_position - global_position,
			0.8,
			Tween.TRANS_SINE,
			Tween.EASE_OUT)
	$Tween.connect("tween_all_completed", self, "on_throw_complete")
	$Tween.start()

func update_point0(new_pos):
	$Line2D.set_point_position(1, new_pos)

func on_throw_complete():
	emit_signal("attached")
	init()
