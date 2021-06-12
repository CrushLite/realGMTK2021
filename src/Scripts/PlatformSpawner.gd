extends Path2D

export var speed = 400
onready var platform_tscn = preload("res://Scenes/platform.tscn")

onready var platform_tscns = [
	preload("res://Scenes/Icebergs/iceberg-1.tscn"),
	preload("res://Scenes/Icebergs/iceberg-2.tscn"),
	preload("res://Scenes/Icebergs/iceberg-2b.tscn"),
	preload("res://Scenes/Icebergs/iceberg-3.tscn"),
	preload("res://Scenes/Icebergs/iceberg-4.tscn")
]

func _physics_process(delta):
	$PathFollow2D.offset += speed * delta


func _on_SpawnTimer_timeout():
	var platform_scene = platform_tscns[randi() % platform_tscns.size()]
	var platform = platform_scene.instance()
#	var platform = platform_tscn.instance()
	platform.position = $PathFollow2D.position
	$SpawnedPlatforms.add_child(platform)
	print("spawning")
	pass # Replace with function body.
