extends RigidBody2D
signal hit

#@export var speed = 200
@export var jump_impulse = 200
var screen_size

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_walk = $CollisionWalk
@onready var collision_crouch = $CollisionCrouch

func _ready() -> void:
	screen_size = get_viewport_rect().size
	animated_sprite.play("walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("jump"): # and position.y == 0:
		position.y -= jump_impulse * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		
	if Input.is_action_pressed("crouch"):
		animated_sprite.animation = "crouch"
		collision_crouch.set_deferred("disabled", false)
		collision_walk.set_deferred("disabled", true)
	else:
		animated_sprite.animation = "walk"
		collision_walk.set_deferred("disabled", false)
		collision_crouch.set_deferred("disabled", true)
			
	#position.x += speed * delta
	


func _on_body_entered(body: Node2D) -> void:
	animated_sprite.play("dead")
	hit.emit()
	collision_walk.set_deferred("disabled", true)
	collision_crouch.set_deferred("disabled", true)
