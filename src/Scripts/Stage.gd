extends Node2D

signal game_over

func _ready():
	$Player.connect("drowned", self, "_on_player_drowned")
	$BlackDeath/AnimationPlayer.connect("animation_finished", self, "_on_death_complete")

func _on_player_drowned():
	# initiate the black death,
	$BlackDeath.visible = true
	$BlackDeath.position = $Player.position
	$BlackDeath/AnimationPlayer.play("zoom")
	# wait for the animation to finish

func _on_death_complete(anim_name):
	# tell the level manager we lost
	print("Emitting game over", anim_name)
	emit_signal("game_over")
