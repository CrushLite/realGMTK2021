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


func _on_CreditsScreen_gui_input(event):
	event = event as InputEventMouseButton
	if event:
		pass
	pass # Replace with function body.


func transition():
	# fades to black then back to white
	pass
