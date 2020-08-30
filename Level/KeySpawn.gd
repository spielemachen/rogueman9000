extends Node2D

var Key = preload("res://Collectibles/Key.tscn")

func spawn_key():
	var spawn_points = get_children()
	spawn_points.shuffle()
	var key = Key.instance()
	add_child(key)
	key.global_position = spawn_points[0].global_position

