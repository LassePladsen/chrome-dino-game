extends Node
signal hit

const ENEMY_HIGH_SPAWN = Vector2(1000, 350)
const ENEMY_LOW_SPAWN = Vector2(1000, 420)
const BIRD = preload("res://enemies/bird.tscn")


func _ready() -> void:
	print("ready")
	new_game()

func game_over() -> void:
	print("game over")
	$Player.die()
	$EnemyTimer.stop()
	
func new_game() -> void:
	print("new game")
	$Player.start()
	$StartTimer.start()

func _on_start_timer_timeout() -> void:
	print("start timer timeout")
	$StartTimer.stop()
	$EnemyTimer.start()

func _on_enemy_timer_timeout() -> void:
	print("mob timer timeout")
	# Spawn random mob
	
	# Hardcode bird for now
	var enemy = BIRD.instantiate()
	enemy.position = ENEMY_HIGH_SPAWN
	print("Enemy: ", enemy, enemy.position)
	enemy.connect("hit", game_over)
	add_child(enemy)
	
