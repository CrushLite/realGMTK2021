extends Control

signal play_pressed

func _on_Play_pressed():
	$TitleScreen.hide()
	$Comic.show()
	$Comic/AnimationPlayer.play("fade in")

var cnt = 0
func _on_Comic_gui_input(event):
	if not event is InputEventMouseButton and not event.is_pressed():
		return
	if $Comic/AnimationPlayer.is_playing():
		$Comic/AnimationPlayer.seek(5.9, true)
	else:
		if cnt == 0:
			cnt += 1
			emit_signal("play_pressed")
			$Comic.hide()


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


func _on_TextureRect_gui_input(event):
	event = event as InputEventMouseButton
	if event:
		$WinCard.hide()
		$TitleScreen.show()


