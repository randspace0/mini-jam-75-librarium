extends Area2D

const SPEED := 6.0 * 24.0
var direction := 1

func _physics_process(delta: float) -> void:
	position.x += direction * SPEED * delta
	for body in get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()
		return
