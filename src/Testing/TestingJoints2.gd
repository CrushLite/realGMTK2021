extends Node2D

onready var platform_tscn = preload("res://Scenes/platform.tscn")
onready var rope_tscn = preload("res://Testing/rope_anchor_base.tscn")

var last_platforms = []
var ropes = []

func _ready():
	$platform/rope_anchor_base.init()
	ropes.append($platform/rope_anchor_base)
	pass
#
func _physics_process(delta):
	pass
##	print($platform/rope.rotation)
#
#	if Input.is_action_just_pressed("ui_accept"):
##		var curlen = $platform/rope_anchor_base/rope.rest_length
##		$platform/rope_anchor_base/rope.rest_length -= 60
#		$platform/rope_anchor_base.pull(60)
#		$platform/rope_anchor_base/rope.rest_length = max(curlen-60, 0.01)
		
#		print($platform/rope_anchor_base/rope.rest_length)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
#		$platform2.position = get_global_mouse_position()
		$platform2.add_torque(1000)
		
		return
		pass # spawn a platform under the mouse
		var plat = platform_tscn.instance()
		plat.acceleration = Vector2.ZERO
		plat.initial_speed = 0
		
		plat.position = get_global_mouse_position()
		plat.rotate(randi() % 6)
		add_child(plat)
		last_platforms.append(plat)
	
	if event.is_action_pressed("throw_rope") and last_platforms.size() > 1:
		# create an anchor on the last two platforms
		var rope_base = rope_tscn.instance()
		rope_base.position = Vector2(40,40) #get_global_mouse_position() - last_platforms[0].global_position
		last_platforms[0].add_child(rope_base)
		
		# spawn the target object
		var target = Position2D.new()
		#move the target to the target position and reparent it to the target platform
		target.position = get_global_mouse_position() - last_platforms[1].global_position # Vector2() # just put it in the center of the plat
		last_platforms[1].add_child(target)
		
		# assign the target
		rope_base.anchor_target_path = target.get_path()
		
		rope_base.init()
		
		print("%s,   %s vs %s" % [target.position, target.global_position, get_global_mouse_position()])
		ropes.append(rope_base)
		
		
	if event.is_action_pressed("pull_rope"):
		#pull
		for rope in ropes:
			print(rope.rotation)
			rope.pull(60)
		
