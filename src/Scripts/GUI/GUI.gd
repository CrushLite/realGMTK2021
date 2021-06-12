extends Control

signal play_pressed

func _on_Play_pressed():
	hide()
	emit_signal("play_pressed")


func _on_Options_pressed():
	$TitleScreen.hide()
	$ControlsScreen.show()


func _on_Back_pressed():
	$TitleScreen.show()
	$ControlsScreen.hide()
