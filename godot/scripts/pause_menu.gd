extends CanvasLayer

const UiTheme := preload("res://scripts/ui_theme.gd")
# Esc toggles pause; Resume / Restart / Main Menu.

var _panel := ColorRect.new()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 10
	_panel.color = Color(0.21, 0.09, 0.16, 0.8)
	_panel.theme = UiTheme.make()
	_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	_panel.visible = false
	add_child(_panel)
	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_CENTER)
	box.grow_horizontal = Control.GROW_DIRECTION_BOTH
	box.grow_vertical = Control.GROW_DIRECTION_BOTH
	box.add_theme_constant_override("separation", 12)
	_panel.add_child(box)
	var title := Label.new()
	title.text = "Paused"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", UiTheme.BG)
	box.add_child(title)
	_button(box, "Resume", _toggle)
	_button(box, "Restart", Game.retry)
	_button(box, "Main Menu", Game.to_menu)

func _button(parent: Control, text: String, cb: Callable) -> void:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(260, 52)
	b.pressed.connect(cb)
	parent.add_child(b)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		_toggle()

func _toggle() -> void:
	var p := not get_tree().paused
	get_tree().paused = p
	_panel.visible = p
