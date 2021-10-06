extends Button

var scene = Node2D
var player = RigidBody2D

func _ready():
	scene = get_parent().get_parent().get_parent()
	player = get_parent().get_parent().get_parent().get_node("Player")

func _pressed():
	player.ready_to_tp = true
	player.apply_central_impulse(player.get_linear_velocity()*-1)
	yield(get_tree().create_timer(0.1), "timeout")
	get_parent().get_parent().visible = false
	scene.timer_limit = 1.5
	for dart in scene.darts:
		scene.remove_child(dart)
	scene.darts = []
	scene.is_playing = true
	scene.points = 0
	scene.get_node("Points/Label").text = "0"
	scene.current_level = scene.current_level + 1
