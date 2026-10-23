extends StaticBody2D
# Wood-ability platform: grows out of the ground.

func _ready() -> void:
	scale = Vector2(2, 0.02)
	create_tween().tween_property(self, "scale:y", 2.0, 0.6).set_trans(Tween.TRANS_QUAD)
