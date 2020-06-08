extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var map_path: NodePath

var parent
var map: TileMap

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	parent = get_parent()
	map = get_node(map_path)

func _input(event):
	var pos_change

	if event.is_action_pressed("ui_left"):
		pos_change = Vector2.LEFT;
	if event.is_action_pressed("ui_right"):
		pos_change = Vector2.RIGHT;
	if event.is_action_pressed("ui_up"):
		pos_change = Vector2.UP;
	if event.is_action_pressed("ui_down"):
		pos_change = Vector2.DOWN;

	if pos_change != null:
		parent.position = map.map_to_world(map.world_to_map(parent.position) + pos_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
