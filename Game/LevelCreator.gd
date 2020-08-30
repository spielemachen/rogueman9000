extends Node

onready var reference_map: TileMap = $ReferenceMap


export(PackedScene) var StartingRoom
export(PackedScene) var EndRoom
export(Array, PackedScene) var rooms

func create_level(level):
	randomize()
	
	var room_directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	
	var available_room_positions = [Vector2(0,0)]
	var used_room_positions = []
	var room_by_position = {}
	var amount_rooms = 2 + level
	
	while used_room_positions.size() < amount_rooms:
		available_room_positions.shuffle()
		
		var current_position = available_room_positions.pop_back()
		
		var current_room
		if (used_room_positions.size() == 0):
			current_room = StartingRoom.instance()	
		elif (used_room_positions.size() == amount_rooms - 1):
			current_room = EndRoom.instance()
			current_room.find_node("Doors").activate_doors(level)
		else:
			rooms.shuffle()
			current_room = rooms[0].instance()
	
		used_room_positions.push_back(current_position)

		for room_direction in room_directions:
			var new_room_position = current_position + room_direction * Config.grid_size * Config.room_size
			if used_room_positions.find(new_room_position) == -1:
				available_room_positions.push_back(new_room_position)
			else:
				current_room.find_node("Map").open_to(room_direction)
				room_by_position[new_room_position].find_node("Map").open_to(room_direction * -Vector2.ONE)

		add_child(current_room)
		current_room.position = current_position
		room_by_position[current_position] = current_room

	var key_spawns = get_tree().get_nodes_in_group("KeySpawn")
	for key_spawn in key_spawns:
		key_spawn.spawn_key()
