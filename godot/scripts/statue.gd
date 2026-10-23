extends Node2D
# Stone -> Wood -> OnFire -> Burnt. Emits `burnt` on the final step.

signal burnt

const TEX := "res://assets/tex/Statue/"
var state := "stone"

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	var f := SpriteFrames.new()
	f.remove_animation("default")
	_still(f, "stone", "statue_rock.png")
	_still(f, "wood", "statue_wood.png")
	_still(f, "burnt", "statue_burnt.png")
	for k in ["wood", "fire", "water"]:
		var tex: Texture2D = load(TEX + "statue_given_%s.png" % k)
		f.add_animation("given_" + k)
		f.set_animation_speed("given_" + k, 8)
		f.set_animation_loop("given_" + k, false)
		for i in 5:
			var a := AtlasTexture.new()
			a.atlas = tex
			a.region = Rect2(i * 56, 0, 56, 66)
			f.add_frame("given_" + k, a)
	sprite.sprite_frames = f
	sprite.play("stone")
	sprite.animation_finished.connect(_on_anim_done)

func _still(f: SpriteFrames, anim: String, file: String) -> void:
	f.add_animation(anim)
	f.set_animation_loop(anim, false)
	f.add_frame(anim, load(TEX + file))

func spell(kind: String) -> bool:
	if kind == "wood" and state == "stone":
		state = "wood"
	elif kind == "fire" and state == "wood":
		state = "fire"
	elif kind == "water" and state == "fire":
		state = "burnt"
	else:
		return false
	sprite.play("given_" + kind)
	return true

func _on_anim_done() -> void:
	match state:
		"wood":
			sprite.play("wood")
		"burnt":
			sprite.play("burnt")
			burnt.emit()
