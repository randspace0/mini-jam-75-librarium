extends Control

func _ready() -> void:
	Game.play_music("menu")
	var bg := TextureRect.new()
	bg.texture = load("res://assets/tex/Menu/menu.png")
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(bg)
	var play := _button("play", Vector2(480, 440))
	play.pressed.connect(func(): Game.start_level(1))
	var credits := _button("credits", Vector2(700, 440))
	credits.pressed.connect(func(): OS.shell_open("https://github.com/randspace0/mini-jam-75-librarium"))

func _button(name_: String, pos: Vector2) -> TextureButton:
	var b := TextureButton.new()
	b.texture_normal = load("res://assets/tex/Menu/%s_closed.png" % name_)
	b.texture_hover = load("res://assets/tex/Menu/%s_open.png" % name_)
	b.position = pos
	b.scale = Vector2(1.5, 1.5)
	b.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(b)
	return b
