extends Node2D
# Port of Water2DSpawner: emits physics droplets that pool on the ground and expire.
# Droplets live on layer 2 so they never push the player (mask 1) but collide with ground and each other.

const U := 24.0
const RADIUS := 3.0
const LIFETIME := 5.0
const DELAY := 0.05
const MAX_DROPS := 80
const SPRING_SPEED := 9.0 * U  # upward jet, tuned so the stream lifts the log
const AREA := Vector2(800, 600)  # metaball canvas, centred on the spring

var _drops: Array[RigidBody2D] = []
var _timer := 0.0
var _mat := ShaderMaterial.new()

func _ready() -> void:
	_mat.shader = load("res://scripts/water.gdshader")
	_mat.set_shader_parameter("rect_size", AREA)
	_mat.set_shader_parameter("radius", RADIUS)
	var r := ColorRect.new()
	r.size = AREA
	r.position = -AREA / 2.0
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.material = _mat
	add_child(r)

func _physics_process(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0 and _drops.size() < MAX_DROPS:
		_timer = DELAY
		_spawn()
	var pts := PackedVector2Array()
	pts.resize(MAX_DROPS)
	for i in _drops.size():
		pts[i] = to_local(_drops[i].global_position) + AREA / 2.0
	_mat.set_shader_parameter("drops", pts)
	_mat.set_shader_parameter("count", _drops.size())

func _spawn() -> void:
	var d := RigidBody2D.new()
	d.collision_layer = 2
	d.collision_mask = 3
	d.gravity_scale = 1.0
	d.linear_damp = 0.5
	d.physics_material_override = PhysicsMaterial.new()
	d.physics_material_override.bounce = 0.1
	d.physics_material_override.friction = 0.2
	var c := CollisionShape2D.new()
	var s := CircleShape2D.new()
	s.radius = RADIUS
	c.shape = s
	d.add_child(c)
	d.position = Vector2(randf_range(-6.0, 6.0), -RADIUS - 1.0)
	d.linear_velocity = Vector2(randf_range(-0.3, 0.3) * U, -SPRING_SPEED * randf_range(0.7, 1.0))
	add_child(d)
	_drops.append(d)
	get_tree().create_timer(LIFETIME).timeout.connect(_expire.bind(d))

func _expire(d: RigidBody2D) -> void:
	_drops.erase(d)
	if is_instance_valid(d):
		d.queue_free()

