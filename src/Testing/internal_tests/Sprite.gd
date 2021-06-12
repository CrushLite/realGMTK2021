extends Sprite

var rotation_point = Vector2(0, 0)
var rotation_around_point = 0
var distance_from_point = 10


func _process(delta):
	# set the position to the point
#	global_position = rotation_point
	distance_from_point = global_position.distance_to(rotation_point)
	global_position = Vector2(0,0)
	# offset using the rotation
	global_position += Vector2(cos(rotation_around_point), sin(rotation_around_point)) * distance_from_point
	rotation_around_point += delta
