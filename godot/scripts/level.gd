extends Node2D
# Builds a level from Unity-exported data. Positions are Unity units (y up); 24 px per unit.

const U := 24.0
const TILES_DIR := "res://assets/tex/Tiles/"
const Tiles := preload("res://scripts/tile_data.gd")

const DATA := {
	1: {
		"player": Vector2(-6.72, -0.74),
		"statue": Vector2(12.55, -0.61), "pedestal": Vector2(10.05, -2.03),
		"books": {"wood": Vector2(-2.97, -1.195), "water": Vector2(13.09, 6.81), "fire": Vector2(-6.15, 10.93)},
		"log": Vector2(7.49, 4.56),
	},
	2: {
		"player": Vector2(-6.72, -0.74),
		"statue": Vector2(-7.7, 5.52), "pedestal": Vector2(-4.93, 4.10),
		"books": {"wood": Vector2(-2.97, -1.195), "water": Vector2(4.88, 8.57), "fire": Vector2(-2.99, 13.83)},
		"log": Vector2(-1.01, 12.33),
	},
}

@export var number := 1

var _label := Label.new()

func _p(v: Vector2) -> Vector2:
	return Vector2(v.x * U, -v.y * U)

func _ready() -> void:
	var d: Dictionary = DATA[number]
	_build_tiles()
	var statue: Node2D = load("res://scenes/statue.tscn").instantiate()
	statue.position = _p(d.statue - Vector2(0, 1.375))
	statue.burnt.connect(_on_burnt)
	add_child(statue)
	_build_pedestal(d.pedestal, statue)
	_build_log(d.log)
	for kind in d.books:
		var b: Node2D = load("res://scenes/book.tscn").instantiate()
		b.kind = kind
		b.position = _p(d.books[kind])
		add_child(b)
	var player: Node2D = load("res://scenes/player.tscn").instantiate()
	player.position = _p(d.player)
	player.died.connect(Game.retry)
	add_child(player)
	_build_hud()

func _build_tiles() -> void:
	var body := StaticBody2D.new()
	body.collision_layer = 1
	add_child(body)
	var textures := []
	for n in Tiles.TILE_NAMES:
		textures.append(load(TILES_DIR + n + ".png") if n != "tile_ground_simple" else load("res://assets/tex/tile_ground_simple.png"))
	for t in Tiles.TILES[number]:
		var s := Sprite2D.new()
		s.texture = textures[t[2]]
		s.scale = Vector2(4, 4)
		s.position = Vector2((t[0] + 0.5) * U, -(t[1] + 0.5) * U)
		body.add_child(s)
		var c := CollisionShape2D.new()
		var r := RectangleShape2D.new()
		r.size = Vector2(U, U)
		c.shape = r
		c.position = s.position
		body.add_child(c)

func _build_pedestal(pos: Vector2, statue: Node2D) -> void:
	var p := StaticBody2D.new()
	p.set_script(load("res://scripts/pedestal.gd"))
	p.collision_layer = 1
	p.add_to_group("pedestal")
	p.position = _p(pos)
	var c := CollisionShape2D.new()
	var r := RectangleShape2D.new()
	r.size = Vector2(1.79 * U, 0.147 * U)
	c.shape = r
	p.add_child(c)
	var v := ColorRect.new()
	v.color = Color(0.45, 0.4, 0.5)
	v.size = r.size
	v.position = -r.size / 2.0
	p.add_child(v)
	add_child(p)
	p.statue_path = p.get_path_to(statue)

func _build_log(pos: Vector2) -> void:
	var l := RigidBody2D.new()
	l.collision_layer = 1
	l.position = _p(pos)
	var s := Sprite2D.new()
	s.texture = load("res://assets/tex/log.png")
	s.scale = Vector2(4, 4)
	l.add_child(s)
	var c := CollisionShape2D.new()
	var r := RectangleShape2D.new()
	r.size = Vector2(4.7 * U, 1.0 * U)
	c.shape = r
	l.add_child(c)
	add_child(l)

func _build_hud() -> void:
	var layer := CanvasLayer.new()
	_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.position.y = 24
	_label.add_theme_font_size_override("font_size", 32)
	layer.add_child(_label)
	add_child(layer)
	var pause := CanvasLayer.new()
	pause.set_script(load("res://scripts/pause_menu.gd"))
	add_child(pause)
	_label.text = "Esc pause  |  Arrows move  |  Space cast  |  Q drop book"

func _on_burnt() -> void:
	var last: bool = number >= Game.LEVELS.size()
	_label.text = "The End" if last else "The statue burns..."
	await get_tree().create_timer(3.0 if last else 2.0).timeout
	Game.next_level()
