extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("fly")
	
func stop():
	super.stop()
	$AnimatedSprite2D.pause()
	
