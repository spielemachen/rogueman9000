class_name TileMapMerger
extends Node

export var target_map: NodePath
export(Array, NodePath) var source_maps

func merge_maps():
	var target = get_node(target_map) as TileMap
	var max_region = Vector2.ZERO
	var min_region = Vector2.ZERO
	for source_map in source_maps:
		var source = get_node(source_map) as TileMap
		var starting_position = source.global_position / Config.grid_size / Config.room_size
		for x in range(0, Config.room_size.x):
			for y in range(0, Config.room_size.y):
				var tile = source.get_cell(x, y);
				
				var new_pos_x = starting_position.x * Config.room_size.x + x
				var new_pos_y = starting_position.y * Config.room_size.y + y
				
				target.set_cell(new_pos_x, new_pos_y, tile)
				
				if max_region.x < new_pos_x:
					max_region.x = new_pos_x
				if max_region.y < new_pos_y:
					max_region.y = new_pos_y
				if min_region.x > new_pos_x:
					min_region.x = new_pos_x
				if min_region.y > new_pos_y:
					min_region.y = new_pos_y
					
		source.queue_free()
	target.update_bitmask_region(min_region, max_region)

