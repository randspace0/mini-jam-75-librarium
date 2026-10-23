extends CharacterBody2D
# Port of PlayerController + the three abilities. 24 px = 1 Unity unit.

const U := 24.0
const SPEED := 5.0 * U
const JUMP_VELOCITY := -6.0 * U
const COOLDOWN := 3.0
const TEX := "res://assets/tex/Character/"

signal died

var held := ""  # "", "fire", "water", "wood"
var facing := 1  # +1 right; art faces right
var cooldown := 0.0
var stump: Node2D
var water: Node2D
var _was_grounded := true

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	sprite.sprite_frames = _build_frames()
	sprite.play("idle")

func _build_frames() -> SpriteFrames:
	var f := SpriteFrames.new()
	f.remove_animation("default")
	_add(f, "idle", "char_still.png", 24, 24, 1, 1, false)
	_add(f, "run", "run.png", 24, 28, 6, 12, true)
	_add(f, "jump_up", "jump.png", 24, 28, 3, 8, false)
	_add(f, "fall", "jump.png", 24, 28, 3, 8, false, 3)
	for b in ["fire", "water", "wood"]:
		_add(f, "idle_" + b, "char_%s_still.png" % b, 24, 30, 1, 1, false)
		_add(f, "walk_" + b, "walk_%s.png" % b, 24, 28, 3, 8, true)
		_add(f, "use_" + b, "use_%s.png" % b, 24, 28, 2, 8, false)
	return f

func _add(f: SpriteFrames, anim: String, file: String, w: int, h: int, count: int, fps: float, loop: bool, first := 0) -> void:
	var tex: Texture2D = load(TEX + file)
	f.add_animation(anim)
	f.set_animation_speed(anim, fps)
	f.set_animation_loop(anim, loop)
	var tw: int = tex.get_width()
	for i in count:
		var a := AtlasTexture.new()
		a.atlas = tex
		# Whole-image strips for single frames, since still sprites differ in height.
		a.region = Rect2((first + i) * w, 0, w, h) if tw > w else Rect2(0, 0, tw, tex.get_height())
		f.add_frame(anim, a)

func _physics_process(delta: float) -> void:
	cooldown = maxf(cooldown - delta, 0.0)
	var dir := Input.get_axis("move_left", "move_right")
	velocity.x = dir * SPEED
	velocity.y += get_gravity().y * delta
	# Original rule: holding a book makes you too heavy to jump.
	if Input.is_action_pressed("jump") and is_on_floor() and held == "":
		velocity.y = JUMP_VELOCITY
	move_and_slide()
	if dir != 0.0 and int(signf(dir)) != facing:
		facing = int(signf(dir))
		sprite.flip_h = facing < 0
		$FirePoint.position.x = absf($FirePoint.position.x) * facing
	if Input.is_action_just_pressed("cast") and held != "":
		_cast()
	if Input.is_action_just_pressed("drop") and held != "":
		_drop()
	_animate(dir)
	if global_position.y > 60.0 * U:
		died.emit()

func _animate(dir: float) -> void:
	var suffix := "" if held == "" else "_" + held
	if sprite.animation.begins_with("use_") and sprite.is_playing():
		return
	if not is_on_floor():
		sprite.play("jump_up" if velocity.y < 0 else "fall")
	elif dir != 0.0:
		sprite.play("run" if held == "" else "walk" + suffix)
	else:
		sprite.play("idle" if held == "" else "idle" + suffix)

func pick_up(kind: String) -> bool:
	if held != "":
		return false
	held = kind
	return true

func _drop() -> void:
	var book: Node2D = load("res://scenes/book.tscn").instantiate()
	book.kind = held
	book.untakeable_for = 3.0
	book.global_position = $FirePoint.global_position
	get_parent().add_child(book)
	held = ""
	_clear_effects()

func _clear_effects() -> void:
	for n in [stump, water]:
		if is_instance_valid(n):
			n.queue_free()
	stump = null
	water = null

func _ground_hit() -> Dictionary:
	var q := PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0, 2000), 1)
	return get_world_2d().direct_space_state.intersect_ray(q)

func _cast() -> void:
	if cooldown > 0.0:
		return
	var hit := _ground_hit()
	if held == "fire":
		_play_use()
		if hit and hit.collider.is_in_group("pedestal"):
			hit.collider.spell("fire")
		else:
			var fb: Node2D = load("res://scenes/fireball.tscn").instantiate()
			fb.global_position = $FirePoint.global_position
			fb.direction = facing
			get_parent().add_child(fb)
	elif not hit:
		return  # water/wood need ground to act on
	else:
		_play_use()
		if held == "water":
			_clear_effects_one("water")
			if hit.collider.is_in_group("pedestal"):
				hit.collider.spell("water")
			else:
				water = load("res://scenes/water.tscn").instantiate()
				water.global_position = hit.position
				get_parent().add_child(water)
		elif held == "wood":
			if hit.collider.is_in_group("pedestal"):
				hit.collider.spell("wood")
			else:
				_clear_effects_one("wood")
				stump = load("res://scenes/stump.tscn").instantiate()
				stump.global_position = hit.position
				get_parent().add_child(stump)
	cooldown = COOLDOWN

func _clear_effects_one(which: String) -> void:
	var n = water if which == "water" else stump
	if is_instance_valid(n):
		n.queue_free()

func _play_use() -> void:
	sprite.play("use_" + held)
