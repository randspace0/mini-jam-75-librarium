extends Area2D
# Collectible spell book. kind: "fire" | "water" | "wood".

@export_enum("fire", "water", "wood") var kind := "fire"
var untakeable_for := 0.0
var _t := 0.0

func _ready() -> void:
	$Sprite.texture = load("res://assets/tex/Book/book_%s.png" % kind)

func _physics_process(delta: float) -> void:
	_t += delta
	$Sprite.position.y = sin(_t * 3.0) * 1.5
	untakeable_for = maxf(untakeable_for - delta, 0.0)
	if untakeable_for > 0.0:
		return
	for body in get_overlapping_bodies():
		if body.has_method("pick_up") and body.pick_up(kind):
			queue_free()
			return
