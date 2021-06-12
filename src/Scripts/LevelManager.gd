extends Control

onready var main_scene = preload("res://Scenes/Stage.tscn")
var curr_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	$GUI.connect("play_pressed", self, "_on_play_pressed")


func _on_play_pressed():
	var scene = main_scene.instance()
	scene.connect("game_over", self, "_on_scene_ended")
	add_child(scene)
	curr_scene = scene


func _on_scene_ended():
	print("scene ended")
	curr_scene.queue_free()
	$GUI.show()
