extends Control



func _on_Play_pressed():
	hide()


func _on_Options_pressed():
	$TitleScreen.hide()
	$ControlsScreen.show()
