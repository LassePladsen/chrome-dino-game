class_name Player
extends CharacterBody2D

const START_VELOCITY = Vector2(700, 0)
const SPEED_INCREASE = 30 # adds to speed every physics calculation
const MAX_SPEED = 2000
const JUMP_SPEED = -1350
const CROUCH_SPEED = 80
const START_POS = Vector2(0, -40)
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_walk = $CollisionWalk
@onready var collision_crouch = $CollisionCrouch
var dead = false

func _ready() -> void:
	start()

func _physics_process(delta: float) -> void:
	if dead: return
	
	# Add the gravity.
	if not is_on_floor(): velocity += get_gravity() * delta
	
	# Crouch position
	if Input.is_action_pressed("crouch"):
		animated_sprite.animation = "crouch"
		collision_crouch.set_deferred("disabled", false)
		collision_walk.set_deferred("disabled", true)
		
		# Stop upwards momentum if exists, also add constant speed downwards
		if not is_on_floor(): 
			if velocity.y < 0: velocity.y = 0
			velocity.y += CROUCH_SPEED
	
	# Normal walk position
	else:
		# Jump if not crouched
		if Input.is_action_pressed("jump") and is_on_floor(): velocity.y = JUMP_SPEED
		
		animated_sprite.animation = "walk"
		collision_walk.set_deferred("disabled", false)
	
	velocity.x = min(velocity.x + SPEED_INCREASE * delta, MAX_SPEED)
	move_and_slide()

func die() -> void:
	dead = true
	velocity.x = 0
	print("player die")
	animated_sprite.animation = "dead"
	animated_sprite.stop()
	collision_walk.set_deferred("disabled", true)
	collision_crouch.set_deferred("disabled", true)
	
func start() -> void:
	position = START_POS
	velocity = START_VELOCITY
	dead = false
	print("player start")
	animated_sprite.play("walk")
	collision_walk.set_deferred("disabled", false)
	collision_crouch.set_deferred("disabled", true)
	
