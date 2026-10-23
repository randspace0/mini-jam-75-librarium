extends Node

func _ready() -> void:
	add_child(load("res://scenes/level_1.tscn").instantiate())
	await get_tree().create_timer(0.3).timeout
	var pm: CanvasLayer = get_children()[0].get_children().filter(func(n): return n is CanvasLayer and n.has_method("_toggle"))[0]
	pm._toggle()
	await get_tree().create_timer(0.2).timeout
	print("paused=", get_tree().paused)
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(OS.get_cmdline_user_args()[0])
	pm._toggle()
	print("resumed paused=", get_tree().paused)
	get_tree().quit()
