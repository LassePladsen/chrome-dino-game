extends Enemy
@onready var animation = $AnimatedSprite2D
@onready var main = $/root/Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("fly")

func _process(delta: float) -> void:
	if main and main.is_game_over: animation.pause()
	
