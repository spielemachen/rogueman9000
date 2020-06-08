extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var parent

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	parent = get_parent()

func _process(delta):
	parent.position.x += delta * 15

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
