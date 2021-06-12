extends Area2D

# Spawns random platforms and gives them a random speed and rotation
# also handles the collision mask so that they can go over the wall boundary

export(Array, PackedScene) var icebergs




func _on_Timer_timeout():
	var random_iceberg = icebergs[randi() % icebergs.size()]
	var iceberg: RigidBody2D = random_iceberg.instance()
	iceberg.position = Vector2(0,0)
	iceberg.apply_central_impulse(Vector2(0, 1000))
	iceberg.apply_torque_impulse(3000)
	print(iceberg.collision_layer)
	iceberg.collision_layer = 2
	iceberg.collision_mask = 2
	$SpawnedIcebergs.add_child(iceberg)
	pass # Replace with function body.




func _on_WaterfallSpawner_body_exited(body):
	print("BLAH")
	if body.is_in_group("platforms"):
		print("platform left")
		print(body.collision_layer)
		body.collision_layer = 1
		body.collision_mask = 1
	pass # Replace with function body.
