class_name Enemy
extends Area2D
signal hit

const SPEED = -10
var vx = SPEED

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _process(delta: float) -> void:
	position.x += vx
	
# On player enter
func _on_body_entered(body: Player) -> void:
	print("Body entered ", self.name , " :", body)
	stop()
	hit.emit()

func stop():
	vx = 0
	
func start(): 
	vx = SPEED
	
