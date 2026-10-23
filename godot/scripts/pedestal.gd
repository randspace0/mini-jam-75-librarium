extends StaticBody2D

@export var statue_path: NodePath

func spell(kind: String) -> void:
	var s := get_node_or_null(statue_path)
	if s:
		s.spell(kind)
