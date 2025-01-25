class_name Player
extends CharacterBody2D
signal hit

const JUMP_VELOCITY = -1200
const CROUCH_VELOCITY = 80
@onready var screen_size = get_viewport_rect().size
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_walk = $CollisionWalk
@onready var collision_crouch = $CollisionCrouch

func _ready() -> void:
	animated_sprite.play("walk")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor(): velocity += get_gravity() * delta
	
	# Crouch position
	if Input.is_action_pressed("crouch"):
		animated_sprite.animation = "crouch"
		collision_crouch.set_deferred("disabled", false)
		collision_walk.set_deferred("disabled", true)
		if not is_on_floor(): velocity.y += CROUCH_VELOCITY
	
	# Normal walk position
	else:
		# Jump if not crouched
		if Input.is_action_pressed("jump") and is_on_floor(): velocity.y = JUMP_VELOCITY
		animated_sprite.animation = "walk"
		collision_walk.set_deferred("disabled", false)

	move_and_slide()

func _on_body_entered(body: Area2D) -> void:
	animated_sprite.play("dead")
	hit.emit()
	collision_walk.set_deferred("disabled", true)
	collision_crouch.set_deferred("disabled", true)
