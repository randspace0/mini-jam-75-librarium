extends Node
# Usage: godot --path . res://test/shot.tscn -- <level> <out.png>

func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	var lvl := int(args[0])
	add_child(load("res://scenes/level_%d.tscn" % lvl).instantiate())
	for i in 90:
		await get_tree().physics_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(args[1])
	get_tree().quit()
