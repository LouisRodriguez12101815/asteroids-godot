extends Area2D

signal hit

const MIN_RADIUS := 20.0

var velocity := Vector2.ZERO
var radius := 20.0


func _ready() -> void:
	add_to_group("asteroids")
	# Create collision shape matching our radius
	var shape := CircleShape2D.new()
	shape.radius = radius
	$CollisionShape2D.shape = shape


func setup(r: float, vel: Vector2) -> void:
	radius = r
	velocity = vel


func _process(delta: float) -> void:
	position += velocity * delta
	# Remove if far off screen
	if position.x < -200 or position.x > 1480 or position.y < -200 or position.y > 920:
		queue_free()


func split() -> void:
	# If large or medium, spawn 2 smaller asteroids
	if radius > MIN_RADIUS:
		var new_radius := radius / 2.0
		for i in 2:
			var child := duplicate()
			child.radius = new_radius
			child.velocity = velocity.rotated(deg_to_rad(randf_range(-60.0, 60.0))) * 1.3
			get_parent().call_deferred("add_child", child)


func _draw() -> void:
	draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Color.WHITE, 2.0)
