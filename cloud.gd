class_name Cloud

extends Node2D
@onready var main = $/root/Main

const  SPEED = 500
var vx = SPEED
	
func _physics_process(delta: float) -> void:
	if main and not main.is_game_over: position.x += vx * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
