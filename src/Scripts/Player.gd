extends Area2D

export var MAX_SPEED = 200     # pixels per second I believe
export var ACCELERATION = 1000 # Accel for both moving and stopping
export var SLIPPERY = false    # whether the character slides a bit when changing directions

var motion = Vector2.ZERO
var axis = Vector2.ZERO
var platforms = []
var target_platform : RigidBody2D
var last_thrown_rope_path = null
var is_throwing = false

onready var rope_base_tscn = preload("res://Scenes/rope_anchor_base.tscn")


func _physics_process(delta):
	motion = Vector2.ZERO
#	var x = Vector2(0,0)
	var major_platform : RigidBody2D = get_major_platform()
	if major_platform:
		motion += major_platform.linear_velocity
	else:
#		print("we dead")
		pass
	
	var axis = get_input_axis()
	motion += axis * MAX_SPEED
	position += motion * delta
	set_animations(axis, is_throwing)

func _input(event):
	if last_thrown_rope_path:
		var last_rope = get_node_or_null(last_thrown_rope_path)
		if Input.is_action_just_pressed("pull_rope") and last_rope: # and not is_throwing:
			last_rope.pull(60)
			pass
	
	var base_platform = get_major_platform()
	# Throw rope
	if Input.is_action_just_pressed("throw_rope") and target_platform \
		and base_platform and not is_throwing:
		is_throwing = true
		# spawn a rope object
		var rope_base = rope_base_tscn.instance()
		# move the rope_base to the player and reparent it to the platform
		rope_base.position = Vector2()#global_position - base_platform.global_position
		base_platform.add_child(rope_base)
		# spawn the target object
		var target = Position2D.new()
		#move the target to the target position and reparent it to the target platform
		target.position = $Node/MouseFollower.global_position - target_platform.global_position
		target_platform.add_child(target)
		
		# assign the target
		rope_base.anchor_target_path = target.get_path()
		
		#remember that this is the rope we are pulling
		last_thrown_rope_path = rope_base.get_path()
		
		# Initialize the ropes length
		rope_base.launch_rope()
		rope_base.connect("attached", self, "on_rope_attached")
	

func get_major_platform():
	if platforms.size() > 0:
		return platforms[0]
	return null


func _on_body_entered(body):
	if body.is_in_group("platforms"):
#		print("body entered")
		platforms.append(body)
	pass # Replace with function body.

func _on_body_exited(body):
	if body.is_in_group("platforms"):
#		print("body exited")
		platforms.erase(body)
	pass # Replace with function body.


func _on_MouseFollower_body_entered(body):
	if body.is_in_group("platforms"):
		target_platform = body
#		print("target changed")


func _on_MouseFollower_body_exited(body):
	if body.is_in_group("platforms"):
		if body == target_platform:
			target_platform = null
#			print("target lost")




































##### Movement ######

func move(delta: float) -> void:
	
	get_input_axis()
	if SLIPPERY: 
		slide_movement(delta)
	else:
		snappier_movement(delta)
	clamp_motion()
	position += motion * delta
#	motion = move_and_slide(motion, Vector2.UP)
	
##### Subroutines #####



func slide_movement(delta: float) -> void:
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)


func snappier_movement(delta: float) -> void:
	apply_friction(ACCELERATION * delta)
	apply_movement(axis * ACCELERATION * delta * 2)


func apply_friction(amount: float) -> void:
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO


func apply_movement(acceleration) -> void:
	motion += acceleration

func get_input_axis() -> Vector2:
	var axis = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	return axis


func clamp_motion(): # limit the top speed
	motion = motion.clamped(MAX_SPEED)


func set_animations(axis, is_throwing):
	if is_throwing == true:
		$AnimatedSprite.animation = "Yeet"
	elif axis.x > 0:
		$AnimatedSprite.animation = "Walk"
		$AnimatedSprite.flip_h = false
	elif axis.x < 0:
		$AnimatedSprite.animation = "Walk"
		$AnimatedSprite.flip_h = true
	elif axis.y > 0:
		$AnimatedSprite.animation = "Walk"
	elif axis.y < 0:
		$AnimatedSprite.animation = "Walk"
	else:
		$AnimatedSprite.animation = "Idle"


func on_rope_attached():
	is_throwing = false
