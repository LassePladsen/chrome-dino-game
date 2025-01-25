class_name Enemy
extends Area2D
signal hit

const SPEED = -10

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _process(delta: float) -> void:
	position.x += SPEED
	
func _on_body_entered(body: Player) -> void:
	print("body entered enemy: ", body)
	hit.emit()
