extends Area2D

var motion = Vector2(1500, 0)
var time_alive = 0
var lifespan = 1

func _process(delta):
	position += motion.rotated(rotation) * delta
	time_alive += delta
	if time_alive > lifespan:
		queue_free()

var hit = false
func _on_Snowball_area_entered(area):
	if area.name == "Player" and not hit:
		print("Hit player")
#		(area.get_parent() as KinematicBody2D).move_and_slide(
#				motion.rotated(rotation) * 0.5)
		area.push(motion.rotated(rotation))
		
		$AnimatedSprite.play("splash")
		hit = true
#		queue_free()
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "splash":
		print("Splash!")
		queue_free()
	pass # Replace with function body.
