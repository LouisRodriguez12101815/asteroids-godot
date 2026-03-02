extends Area2D

const RADIUS := 5.0
const LIFETIME := 2.0

var velocity := Vector2.ZERO
var age := 0.0


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _process(delta: float) -> void:
	position += velocity * delta
	age += delta
	# Remove after lifetime or if off screen
	if age > LIFETIME:
		queue_free()
	if position.x < -50 or position.x > 1330 or position.y < -50 or position.y > 770:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("asteroids"):
		area.hit.emit()
		area.split()
		area.queue_free()
		queue_free()


func _draw() -> void:
	draw_arc(Vector2.ZERO, RADIUS, 0, TAU, 16, Color.WHITE, 2.0)
