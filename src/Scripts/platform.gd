extends RigidBody2D

export var initial_speed = 300
export var offset = 0.50
export var acceleration = Vector2(-1, 0)
export var rotate = true

#func _physics_process(delta):
func _ready():
#	randomize()
	if rotate:
		rotation_degrees = rand_range(100, -100)
	var rand_speed = initial_speed * (1 + rand_range(-offset, offset))
	apply_central_impulse(Vector2(-1, 0) * rand_speed)


func _physics_process(delta):
	apply_central_impulse(acceleration * delta)
	
	if linear_velocity.length() < initial_speed:
		apply_central_impulse(Vector2(-500, 0) * delta)
	
