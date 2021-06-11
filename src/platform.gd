extends RigidBody2D

export var initial_speed = 300
export var offset = 0.50
export var acceleration = Vector2(-1, 0)

#func _physics_process(delta):
func _ready():
	randomize()
	var rand_speed = initial_speed * (1 + rand_range(-offset, offset))
	apply_central_impulse(Vector2(-1, 0) * rand_speed)


func _physics_process(delta):
	apply_central_impulse(acceleration * delta)
	
