extends StaticBody2D
# Wood-ability platform: grows out of the ground.

func _ready() -> void:
	scale = Vector2(1, 0.01)
	create_tween().tween_property(self, "scale:y", 1.0, 0.6).set_trans(Tween.TRANS_QUAD)
