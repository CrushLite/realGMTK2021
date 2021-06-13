extends AnimatedSprite

onready var snowball_scene = preload("res://Scenes/Snowball.tscn")
var player_path = null

func _ready():
	$Timer.wait_time = rand_range(3, 5)
#	$Timer.start()
	play("idle")

func _on_penguin_animation_finished():
#	print("CHuck!")
	play("idle")
	pass # Replace with function body.


func _on_Timer_timeout():
	if player_path:
		var player = get_node(player_path)
		if player.global_position.x > global_position.x:
			flip_h = true
		else:
			flip_h = false
	play("throwing")
	$subTimer.start()
	pass # Replace with function body.


func _on_subTimer_timeout():
	if player_path:
		print("Spawning snowball")
		var snowball = snowball_scene.instance()
		var player = get_node(player_path)
		var ang = get_angle_to(player.global_position)
		snowball.rotate(ang) # towards the player
		add_child(snowball)
		


func _on_AggroArea_area_entered(area):
	if area.name == "Player":
		$Timer.start()
		player_path = area.get_path()
		_on_subTimer_timeout() # spawn snowball on collide
		print("player entered")
	pass # Replace with function body.


func _on_AggroArea_area_exited(area):
	if area.name == "Player":
		$Timer.stop()
		player_path = null
		print("player exited")
	pass # Replace with function body.
