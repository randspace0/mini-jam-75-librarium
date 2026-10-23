extends RefCounted
# Menu look: sepia palette sampled from assets/tex/Menu/menu.png, pixel font (Silkscreen, OFL).

const BG := Color("bfa997")
const MID := Color("9a7c65")
const ACCENT := Color("724946")
const INK := Color("36172a")

static func make() -> Theme:
	var t := Theme.new()
	t.default_font = load("res://assets/fonts/Silkscreen-Bold.ttf")
	t.default_font_size = 24
	t.set_color("font_color", "Label", INK)
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		t.set_color(state, "Button", INK)
	t.set_stylebox("normal", "Button", _box(MID, ACCENT))
	t.set_stylebox("hover", "Button", _box(BG, INK))
	t.set_stylebox("pressed", "Button", _box(ACCENT, INK))
	t.set_stylebox("focus", "Button", _box(MID, INK))
	return t

static func _box(fill: Color, border: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = fill
	s.border_color = border
	s.set_border_width_all(4)
	s.content_margin_top = 8
	s.content_margin_bottom = 8
	return s
