extends TextureButton

var instructions = Control

func _ready():
	instructions = get_parent()

func _pressed():
	instructions.visible = false;
