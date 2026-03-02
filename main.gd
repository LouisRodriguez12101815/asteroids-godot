extends Node2D

const ASTEROID_SCENE := preload("res://asteroid.tscn")
const SCREEN_WIDTH := 1280
const SCREEN_HEIGHT := 720
const MIN_SPAWN_RATE := 0.3

var score := 0
var game_over := false

@onready var player := $Player
@onready var spawn_timer := $SpawnTimer
@onready var score_label := $HUD/ScoreLabel
@onready var game_over_label := $HUD/GameOverLabel


func _ready() -> void:
	game_over_label.visible = false
	_update_score()


func _process(_delta: float) -> void:
	if game_over and Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()


func _on_spawn_timer_timeout() -> void:
	if game_over:
		return
	_spawn_asteroid()
	# Gradually increase difficulty
	spawn_timer.wait_time = maxf(MIN_SPAWN_RATE, spawn_timer.wait_time - 0.005)


func _spawn_asteroid() -> void:
	var asteroid := ASTEROID_SCENE.instantiate()

	# Random edge spawn (matching original pygame logic)
	var edge := randi() % 4
	var pos: Vector2
	var dir: Vector2

	match edge:
		0: # left
			pos = Vector2(-60, randf() * SCREEN_HEIGHT)
			dir = Vector2(1, 0)
		1: # right
			pos = Vector2(SCREEN_WIDTH + 60, randf() * SCREEN_HEIGHT)
			dir = Vector2(-1, 0)
		2: # top
			pos = Vector2(randf() * SCREEN_WIDTH, -60)
			dir = Vector2(0, 1)
		3: # bottom
			pos = Vector2(randf() * SCREEN_WIDTH, SCREEN_HEIGHT + 60)
			dir = Vector2(0, -1)

	var speed := randf_range(40.0, 100.0)
	dir = dir.rotated(deg_to_rad(randf_range(-30.0, 30.0)))

	# 3 asteroid sizes: small (20), medium (40), large (60)
	var kind := randi_range(1, 3)
	var radius := 20.0 * kind

	asteroid.setup(radius, dir * speed)
	asteroid.position = pos
	asteroid.hit.connect(_on_asteroid_hit)
	add_child(asteroid)


func _on_asteroid_hit() -> void:
	score += 100
	_update_score()


func player_died() -> void:
	game_over = true
	spawn_timer.stop()
	player.visible = false
	player.set_process(false)
	game_over_label.visible = true
	game_over_label.text = "GAME OVER\nScore: %d\n\nPress R to restart" % score


func _update_score() -> void:
	score_label.text = "Score: %d" % score
