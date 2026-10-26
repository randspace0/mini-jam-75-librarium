extends Node
# Usage: godot --path . res://test/water_test.tscn -- <out.png>

func _ready() -> void:
	var lvl: Node = load("res://scenes/level_1.tscn").instantiate()
	add_child(lvl)
	await get_tree().physics_frame
	var p = lvl.get_node("Player") if lvl.has_node("Player") else lvl.get_children().filter(func(n): return n.has_method("pick_up"))[0]
	p.pick_up("water")
	for i in 30:
		await get_tree().physics_frame
	var lg: Node2D = get_tree().get_first_node_in_group("log")
	print("log before ", lg.global_position)
	Input.action_press("cast")
	await get_tree().physics_frame
	Input.action_release("cast")
	for i in 150:
		await get_tree().physics_frame
	print("log after ", lg.global_position)
	var w = p.water
	print("water valid: ", is_instance_valid(w), " drops: ", w._drops.size() if w else -1)
	var below := 0
	for d in w._drops:
		if d.global_position.y > w.global_position.y + 12.0:
			below += 1
	print("drops fallen through ground: ", below, " water at ", w.global_position, " first drop ", w._drops[0].global_position if w._drops.size() else null, " log ", get_tree().get_first_node_in_group("log").global_position)
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(OS.get_cmdline_user_args()[0])
	get_tree().quit()
