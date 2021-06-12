extends Control

onready var main_scene = preload("res://Scenes/Stage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$GUI.connect("play_pressed", self, "_on_play_pressed")


func _on_play_pressed():
	var scene = main_scene.instance()
	add_child(scene)
