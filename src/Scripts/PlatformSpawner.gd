extends Path2D

export var speed = 400
onready var platform_tscn = preload("res://platform.tscn")

func _physics_process(delta):
	$PathFollow2D.offset += speed * delta


func _on_SpawnTimer_timeout():
	var platform = platform_tscn.instance()
	platform.position = $PathFollow2D.position
	$SpawnedPlatforms.add_child(platform)
	print("spawning")
	pass # Replace with function body.
