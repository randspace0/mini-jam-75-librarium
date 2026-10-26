extends Node

func _ready() -> void:
	add_child(load("res://scenes/main_menu.tscn").instantiate())
	await get_tree().create_timer(0.5).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(OS.get_cmdline_user_args()[0])
	get_tree().quit()
