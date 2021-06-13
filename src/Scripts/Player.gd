extends Area2D

signal drowned
signal motion
signal win

export var MAX_SPEED = 200     # pixels per second I believe
export var ACCELERATION = 1000 # Accel for both moving and stopping
export var SLIPPERY = false    # whether the character slides a bit when changing directions
export var screen_shake_pull = 0.3
export var screen_shake_launch = 0.3

var motion = Vector2.ZERO
var axis = Vector2.ZERO
var platforms = []
var target_platform : RigidBody2D
var last_thrown_rope_path = null
var is_throwing = false
var is_pulling = false
var is_drowned = false
var is_landed = false # gets true the first time that we appear on a platform
var is_win = false
var old_rope

var should_grunt = false

#Used to calculate the rotation the player feels if the platform shifts underneath
var current_major_platform = null
var rotation_offset = 0

onready var rope_base_tscn = preload("res://Scenes/rope_anchor_base.tscn")

func _physics_process(delta):
	if should_grunt == true:
		print("should_grunt?")
		should_grunt = false
		$Grunt.play()
	
	
	if is_drowned: # prvent movement if we've drowned
		return
	
	motion = Vector2.ZERO
#	var x = Vector2(0,0)
	var major_platform : RigidBody2D = get_major_platform()
	if major_platform:
		if not is_landed: is_landed = true
		
		motion += major_platform.linear_velocity
		
		# Rotate the player around the platform they are standing on
		if not current_major_platform: 
			current_major_platform = major_platform
			rotation_offset = major_platform.rotation
#			print("rotation offset: ", rotation_offset)
		if current_major_platform != major_platform:
			# we changed platforms
			current_major_platform = major_platform
			rotation_offset = major_platform.rotation
#			print("Changed platforms")
		var change_in_rotation = rotation_offset - current_major_platform.rotation
#		print(change_in_rotation)
		
		#do the rotation
		var target_point: Vector2 = global_position - current_major_platform.global_position
		var a = target_point.angle_to(Vector2(1,0).rotated(change_in_rotation))
		rotation_offset = current_major_platform.rotation
		var rotation_around_point = -a
		var distance_from_point = (target_point).length()
		global_position = current_major_platform.global_position
		global_position += Vector2(cos(rotation_around_point), sin(rotation_around_point)) * distance_from_point
		
		
	elif is_landed:
		is_drowned = true
		emit_signal("drowned")
		print("Drowned")
	
	
	var axis = get_input_axis()
	if not is_throwing:
		motion += axis * MAX_SPEED
	else:
		axis = Vector2()
	
	if not is_win:
		emit_signal("motion", motion)
#	position += motion * delta
	
	set_animations(axis)

func _input(event):
	if last_thrown_rope_path:
		var last_rope = get_node_or_null(last_thrown_rope_path)
		if Input.is_action_just_pressed("pull_rope") and last_rope: # and not is_throwing:
			is_pulling = true
			last_rope.pull(60)
			# screenshake
			var cam = get_tree().get_nodes_in_group("camera")[0]
			cam.add_trauma(screen_shake_pull)
	
	var base_platform = get_major_platform()
	# Throw rope
	if Input.is_action_just_pressed("throw_rope") and target_platform \
		and base_platform and not is_throwing:
		should_grunt = true
		print("Throwing")
		is_throwing = true
		# spawn a rope object
		var rope_base = rope_base_tscn.instance()
		
		
		# Gives the rope_base the platforms rotation
		var target_point: Vector2 = global_position - base_platform.global_position
		var a = target_point.angle_to(Vector2(1,0).rotated(base_platform.rotation))
		var rotation_around_point = -a
		var distance_from_point = (target_point).length()
		rope_base.global_position += Vector2(cos(rotation_around_point), sin(rotation_around_point)) * distance_from_point
		
		
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
		
		# get rid of old rope
		if is_instance_valid(old_rope):
			old_rope.queue_free()
		old_rope = rope_base
		
		# screenshake
		var cam = get_tree().get_nodes_in_group("camera")[0]
		cam.add_trauma(screen_shake_launch)
	

func get_major_platform():
	if platforms.size() > 0:
		return platforms[0]
	return null


func _on_body_entered(body):
	if body.is_in_group("platforms"):
#		print("body entered")
		platforms.append(body)

func _on_area_entered(area):
	if area.is_in_group("victory"):
		# trigger the win animations
		is_win = true
		emit_signal("win")



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


func set_animations(axis):
	if axis.length() > 0:
		is_pulling = false
		is_throwing = false
		if is_instance_valid(old_rope):
			old_rope.queue_free()
	
	if is_win:
		$AnimatedSprite.animation = "Idle"
		pass # TODO: add win animation
	elif is_drowned:
		$AnimatedSprite.play("Drown");
	elif is_throwing == true:
		$AnimatedSprite.play("Yeet");
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
	elif is_pulling == true:
		$AnimatedSprite.animation = "Heave"
	else:
		$AnimatedSprite.animation = "Idle"


func on_rope_attached():
	is_throwing = false


