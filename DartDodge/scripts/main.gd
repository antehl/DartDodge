extends Node2D

var is_playing = false
var points = 0
var timer = 0.0
var timer_limit = 1.5
var player = RigidBody2D
var dart = RigidBody2D
var dart_clone = RigidBody2D
var darts = []
var screen_center = Vector2()
var screen_size = Vector2()
var center_to_corner = Vector2()
var current_level = 0

func _ready():
	player = $"Player"
	dart = $"Dart"
	
	calibrate_size()
	player.transform.origin = screen_center

func calibrate_size():
	screen_size = get_viewport_rect().size
	screen_center = screen_size / 2
	center_to_corner = sqrt(pow(screen_center.x, 2) + pow(screen_center.y, 2))
	dart.transform.origin = screen_center

func _process(delta):
	calibrate_size()
	
	if (!is_playing):
		timer = 0.0
		return
	
	timer += delta
	if (timer < timer_limit):
		return
	timer -= timer_limit
	timer_limit *= 0.98
	
	var dart_clone = dart.duplicate()
	add_child(dart_clone)
	dart_clone.visible = true
	dart_clone.get_child(1).disabled = false
	dart_clone.transform.origin += get_rand_direction()*(center_to_corner + 50)
	dart_clone.transform.origin.x = clamp(dart_clone.get_global_transform().origin.x, -50, screen_size.x + 50)
	dart_clone.transform.origin.y = clamp(dart_clone.get_global_transform().origin.y, -50, screen_size.y + 50)
	darts.append(dart_clone)
	dart_clone.look_at(player.get_global_transform().origin)
	var level = current_level
	yield(get_tree().create_timer(1.5), "timeout")
	if is_playing && level == current_level:
		points += 1
		$"Points/Label".text = String(points)
	yield(get_tree().create_timer(3.5), "timeout")
	darts.erase(dart_clone)
	remove_child(dart_clone)

func _physics_process(delta):
	for i in darts:
		i.apply_central_impulse(i.get_global_transform().basis_xform(Vector2.RIGHT) * 10)

func get_rand_direction():
	randomize()
	var deg = rand_range(0, 360)
	return Vector2(cos(deg), sin(deg))
