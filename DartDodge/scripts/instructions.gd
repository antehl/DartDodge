extends Button

var instructions

func _ready():
	instructions = get_parent().get_parent().get_parent().get_node("Instructions")

func _pressed():
	instructions.visible = true
