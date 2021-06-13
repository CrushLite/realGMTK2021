extends Path2D

export var speed = 400
onready var platform_tscn = preload("res://Scenes/platform.tscn")

onready var platform_tscns = [
	preload("res://Scenes/Icebergs/iceberg-1.tscn"),
	preload("res://Scenes/Icebergs/iceberg-2.tscn"),
	preload("res://Scenes/Icebergs/iceberg-2b.tscn"),
	preload("res://Scenes/Icebergs/iceberg-3.tscn"),
	preload("res://Scenes/Icebergs/iceberg-4.tscn"),
	preload("res://Scenes/Icebergs/iceberg-4.tscn"),
	preload("res://Scenes/Icebergs/iceberg-4.tscn"),
	preload("res://Scenes/Icebergs/iceberg-5.tscn"),
	preload("res://Scenes/Icebergs/iceberg-6.tscn"),
	preload("res://Scenes/Icebergs/iceberg-6.tscn")
]

var base_time


func _ready():
	base_time = $SpawnTimer.wait_time
	_on_SpawnTimer_timeout()


func _physics_process(delta):
	$PathFollow2D.offset += speed * delta


func _on_SpawnTimer_timeout():
	var player = get_tree().get_nodes_in_group("player")[0]
	var player_position = player.global_position
	var line_position = $PathFollow2D.global_position
	var distance_to_player = player_position.distance_to(line_position)
	print(distance_to_player)
	if distance_to_player > 300:
		var platform_scene = platform_tscns[randi() % platform_tscns.size()]
		var platform = platform_scene.instance()
	#	var platform = platform_tscn.instance()
		platform.position = $PathFollow2D.position
		$SpawnedPlatforms.add_child(platform)
		$SpawnTimer.wait_time = base_time*rand_range(.9, 1.1) 
		print("spawning")
		pass # Replace with function body.
