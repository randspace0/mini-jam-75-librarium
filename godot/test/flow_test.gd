extends Node
# Headless check: spawn, land, pick up a book, drive the statue to burnt.

var fails := 0

func check(cond: bool, msg: String) -> void:
	print(("PASS " if cond else "FAIL ") + msg)
	if not cond:
		fails += 1

func frames(n: int) -> void:
	for i in n:
		await get_tree().physics_frame

func _ready() -> void:
	var packed: PackedScene = load("res://scenes/level_1.tscn")
	var level := packed.instantiate()
	add_child(level)
	await frames(60)
	var player: CharacterBody2D = level.get_node("Player") if level.has_node("Player") else level.get_children().filter(func(n): return n is CharacterBody2D)[0]
	var statue: Node2D = level.get_children().filter(func(n): return n.has_method("spell"))[0]
	var ped: Node2D = level.get_children().filter(func(n): return n.is_in_group("pedestal"))[0]
	check(player.is_on_floor(), "player lands on floor (y=%s)" % player.global_position.y)

	# Pick up the nearby wood book by walking onto it.
	var book: Node2D = level.get_children().filter(func(n): return n is Area2D and n.kind == "wood")[0]
	player.global_position = book.global_position
	await frames(5)
	check(player.held == "wood", "picked up wood book")
	check(not is_instance_valid(book) or book.is_queued_for_deletion(), "book consumed")

	# Cast on the pedestal in sequence.
	for kind in ["wood", "fire", "water"]:
		player.held = kind
		player.cooldown = 0.0
		player.global_position = ped.global_position + Vector2(0, -24)
		player.velocity = Vector2.ZERO
		await frames(3)
		player._cast()
		await frames(70)
		print("state after ", kind, ": ", statue.state)
	check(statue.state == "burnt", "statue reached burnt")

	# Wrong order must be rejected.
	var s2 = load("res://scenes/statue.tscn").instantiate()
	add_child(s2)
	await frames(2)
	check(not s2.spell("fire") and not s2.spell("water"), "out-of-order spells rejected")

	# Drop returns a book that can't be re-taken for 3s.
	player.held = "fire"
	player._drop()
	await frames(5)
	check(player.held == "", "drop clears held")
	check(player.held == "", "dropped book not instantly retaken")
	print("FAILS=", fails)
	get_tree().quit(fails)
