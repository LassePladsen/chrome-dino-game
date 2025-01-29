extends Node
signal hit

const ENEMY_DX = 1000 
const ENEMY_DY_HIGH = -120 
const ENEMY_DY_MID = -70
const BIRD = preload("res://enemies/bird.tscn")
const BIG_CACTUS = preload("res://enemies/big_cactus.tscn")
const SMALL_CACTUS = preload("res://enemies/small_cactus.tscn")
const CLOUD = preload("res://cloud.tscn")

var is_game_over: bool = false
var is_ready: bool = true
@onready var player = $Player
@onready var enemy_timer = $EnemyTimer
@onready var start_timer = $StartTimer
@onready var cloud_timer = $CloudTimer
@onready var cloud_spawn_path = $CloudSpawner/CloudSpawnPath
@onready var cloud_max_time = cloud_timer.wait_time * 1.8

func _ready() -> void:
	print("ready")
	new_game()
	
func _process(delta: float) -> void:
	# Start new game on jump, after a respawn delay (start timer)
	if is_game_over and is_ready and Input.is_action_pressed("jump"): new_game()

func game_over() -> void:
	is_game_over = true
	is_ready = false
	start_timer.start()
	enemy_timer.stop()
	cloud_timer.stop()
	print("game over")
	player.die()
	
func new_game() -> void:
	is_game_over = false
	print("new game")
	
	# Delete all enemy and cloud nodes
	for child in self.get_children():
		if child and (child is Enemy or child is Cloud): 
			child.queue_free()
			
	player.start()
	start_timer.start()
	cloud_timer.start()

func _on_start_timer_timeout() -> void:
	# This first block is respawn timer logic. Dont proceed until game is restarted
	is_ready = true
	if is_game_over: return 
	
	print("start timer timeout")
	start_timer.stop()
	enemy_timer.start()

func _on_enemy_timer_timeout() -> void:
	if is_game_over or not is_ready: return
	print("enemy timer timeout")
	spawn_random_enemy()

func spawn_random_enemy() -> void:
	var num = randi_range(0, 2)
	var enemy: Enemy
	var dy: int = 0
	
	# I chose a greater-than if block so that the probabilites for each type of enemy could be easily tweaked
	if num < 1: # Bird
		enemy = BIRD.instantiate()
		match randi_range(0, 1):
			0: dy = ENEMY_DY_HIGH
			1: dy = ENEMY_DY_MID
			
	elif num < 2: # Big cactus
		enemy = BIG_CACTUS.instantiate()
		dy -= 5
	else: # Small cactus
		enemy = SMALL_CACTUS.instantiate()
		dy += 8
	
	add_child(enemy)
	enemy.position = Vector2(player.position.x + ENEMY_DX, player.START_POS.y + dy)
	print("Enemy: ", enemy, enemy.position)
	enemy.connect("hit", game_over)

# Spawn cloud on random spot from CloudSpawnPath at semi-random time interval
func _on_cloud_timer_timeout() -> void:
	var dt = randf_range(cloud_timer.wait_time, cloud_max_time)
	await get_tree().create_timer(dt).timeout
	if is_game_over or not is_ready: return
	print("Cloud timer timeout")
	
	# Spawn cloud on random spot on path
	var cloud = CLOUD.instantiate()
	cloud_spawn_path.progress_ratio = randf()
	cloud.position = Vector2(player.position.x + cloud_spawn_path.position.x, cloud_spawn_path.position.y)
	print("Spawned cloud at pos: ", cloud.position)
	add_child(cloud)
