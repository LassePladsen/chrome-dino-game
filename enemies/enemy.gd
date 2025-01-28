class_name Enemy
extends Area2D
signal hit

var enemy_stack: Array[Enemy] = []

func delete():
	queue_free()
	enemy_stack.pop_front() # oldest enemy will always be the one off screen

func _on_visible_on_screen_notifier_2d_screen_exited():
	delete()

# On player enter
func _on_body_entered(body: Player) -> void:
	print("Body entered ", self.name , ": ", body)
	stop()
	hit.emit()
	
func stop() -> void:
	pass
