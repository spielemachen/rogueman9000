extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var tile_map_path: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.map_path = tile_map_path
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
