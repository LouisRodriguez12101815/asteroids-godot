extends Area2D

const SPEED := 200.0
const TURN_SPEED := 300.0
const SHOOT_SPEED := 500.0
const SHOOT_COOLDOWN := 0.3
const PLAYER_RADIUS := 20.0
const SCREEN_WIDTH := 1280
const SCREEN_HEIGHT := 720

var shot_cooldown := 0.0
var shot_scene := preload("res://shot.tscn")


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _process(delta: float) -> void:
	var main := get_parent()
	if main.game_over:
		return

	shot_cooldown -= delta

	# Rotation
	if Input.is_key_pressed(KEY_A):
		rotation -= deg_to_rad(TURN_SPEED) * delta
	if Input.is_key_pressed(KEY_D):
		rotation += deg_to_rad(TURN_SPEED) * delta

	# Movement
	var forward := Vector2.UP.rotated(rotation)
	if Input.is_key_pressed(KEY_W):
		position += forward * SPEED * delta
	if Input.is_key_pressed(KEY_S):
		position -= forward * SPEED * delta

	# Screen wrapping
	position.x = wrapf(position.x, 0, SCREEN_WIDTH)
	position.y = wrapf(position.y, 0, SCREEN_HEIGHT)

	# Shooting
	if Input.is_key_pressed(KEY_SPACE):
		_shoot()


func _shoot() -> void:
	if shot_cooldown > 0.0:
		return
	var shot := shot_scene.instantiate()
	shot.global_position = global_position
	shot.velocity = Vector2.UP.rotated(rotation) * SHOOT_SPEED
	get_parent().add_child(shot)
	shot_cooldown = SHOOT_COOLDOWN


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("asteroids"):
		get_parent().player_died()


func _draw() -> void:
	var forward := Vector2.UP * PLAYER_RADIUS
	var right := Vector2.RIGHT * PLAYER_RADIUS / 1.5
	var a := forward
	var b := -forward - right
	var c := -forward + right
	draw_polyline([a, b, c, a], Color.WHITE, 2.0)
