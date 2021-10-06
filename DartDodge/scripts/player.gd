extends RigidBody2D

var collision = CollisionObject2D
var velocity = Vector2()
var scene = Node2D
var player_pos = Vector2()
var ready_to_tp = false


func _ready():
	collision = $"Collision"
	scene = get_parent()
 
func _physics_process(delta):
	player_pos = self.position
	if (
		get_colliding_bodies()
		|| player_pos.x < -50
		|| player_pos.x > scene.screen_size.x + 50
		|| player_pos.y < -50
		|| player_pos.y > scene.screen_size.y + 50
	):
		scene.is_playing = false
		var menu = get_parent().get_node("Menu")
		menu.visible = true
		for dart in scene.darts:
			scene.darts.erase(dart)
			scene.remove_child(dart)
	
	if (!scene.is_playing):
		return
	
	if (Input.is_action_just_pressed("click")):
		velocity = (
			self.get_global_transform().origin
			- self.get_global_transform().basis_xform(get_global_mouse_position())
		).normalized()*300
		self.apply_central_impulse(velocity - get_linear_velocity()/2)

func _integrate_forces(state):
	if ready_to_tp:
		var xform = state.get_transform()
		xform.origin = scene.screen_center
		xform.rotated(0.0)
		state.set_transform(xform)
		ready_to_tp = false
