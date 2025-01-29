class_name Enemy
extends Area2D
signal hit

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# On player enter
func _on_body_entered(body: Player) -> void:
	print("Body entered ", self.name , ": ", body)
	hit.emit()
	
