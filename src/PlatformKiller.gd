extends Area2D




func _on_PlatformKiller_body_entered(body):
	if body.is_in_group("platforms"):
		body.queue_free()
