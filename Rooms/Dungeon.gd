extends Node2D

var Room = preload("res://Rooms/Room.tscn")
var Player = preload("res://Actors/Player/Player.tscn")
var ROOM_AMOUNT = 20
var DELETE_RATE = 0.5
var MIN_SIZE = 5
var MAX_SIZE = 10
var player_spawn_point: Vector2

var graph: AStar2D
onready var map: TileMap = $Map 

func _ready():
	randomize()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		generate_dungeon(ROOM_AMOUNT, DELETE_RATE, MIN_SIZE, MAX_SIZE)

func generate_dungeon(room_amount, delete_rate, min_size, max_size):
		$Rooms.free()
		map.clear()
		graph = null
		var roomsContainer = Node.new()
		roomsContainer.name = 'Rooms'
		add_child(roomsContainer)
		for i in range(0, room_amount):
			var room = Room.instance()
			var width = min_size + randi() % (max_size - min_size)
			var height = min_size + randi() % (max_size - min_size)
			$Rooms.add_child(room)
			room.init_room(Vector2.ZERO, Config.grid_size * Vector2(width, height))

		yield(get_tree().create_timer(1.5), 'timeout')

		var room_positions = []		
		for room in $Rooms.get_children():
			if randf() < delete_rate:
				room.queue_free()
			else:
				room.mode = RigidBody2D.MODE_STATIC
				room_positions.push_back(room.position)
		graph = find_mst(room_positions)

		yield(get_tree(), "idle_frame")

		create_map()
		
		map.update_bitmask_region()
		
		Events.emit_signal("level_loaded")

#func _process(delta):
#	update()

#func _draw():
#	for room in $Rooms.get_children():
#		draw_rect(Rect2(room.position - room.size, room.size * 2), Color.red, false)
#	pass
#
#	if graph:
#		for point in graph.get_points():
#			for point_other in graph.get_point_connections(point):
#				var pos1 = graph.get_point_position(point)
#				var pos2 = graph.get_point_position(point_other)
#				draw_line(pos1, pos2, Color.orange, 3, true)
		

func find_mst(nodes: Array):
	
	var graph = AStar2D.new()
	
	# nimm ersten knoten und packe ihn in den graphen
	# entferne diesen aus den noch vorhandenen knoten.
	graph.add_point(graph.get_available_point_id(), nodes.pop_front())
	
	# solange noch knoten vorhanden:
	while nodes:
		var min_distance = INF
		var min_position = null
		var min_point_in_graph = null
		# für jeden knoten im graphen
		for graphNode in graph.get_points():
			var graphNodePos = graph.get_point_position(graphNode)
			# für jeden knoten noch vorhanden:
			for freeNode in nodes:
				# ist die verbindung die bisher kürzeste:
				if freeNode.distance_to(graphNodePos) < min_distance:
					min_distance = freeNode.distance_to(graphNodePos)
					# merke dir diesen knoten
					min_position = freeNode
					min_point_in_graph = graphNode
		
		var new_id = graph.get_available_point_id()
		# füge den gemerkten knoten dem graphen hinzu zusammen 
		graph.add_point(new_id, min_position)
		# mit der kürzesten verbindung
		graph.connect_points(new_id, min_point_in_graph)
		# entferne diesen knoten aus der menge der verbleibenden knoten
		nodes.erase(min_position)
	
	return graph

func create_map():
	if !graph:
		return
	
	map.clear()
	
	var top_left_corner = Vector2(INF, INF)
	var bottom_right_corner = Vector2(-INF, -INF)
	
	var is_player_positioned := false
	
	for room in $Rooms.get_children():
		if player_spawn_point == null:
			player_spawn_point = map.world_to_map(room.position)

		var top_left_corner_room = map.world_to_map(room.position - room.size)
		var bottom_right_corner_room = map.world_to_map(room.position + room.size)
		
		top_left_corner.x = min(top_left_corner.x, top_left_corner_room.x)
		top_left_corner.y = min(top_left_corner.y, top_left_corner_room.y)
		bottom_right_corner.x = max(bottom_right_corner.x, bottom_right_corner_room.x)
		bottom_right_corner.y = max(bottom_right_corner.y, bottom_right_corner_room.y)
		
		for x in range(top_left_corner_room.x + 2, bottom_right_corner_room.x - 1):
			for y in range(top_left_corner_room.y + 2, bottom_right_corner_room.y - 1):
				if !is_player_positioned:
					var player_spawn: Position2D = Position2D.new()
					add_child(player_spawn)
					player_spawn.name = "PlayerSpawnPoint"
					player_spawn.position = map.map_to_world(Vector2(x, y))
					is_player_positioned = true
				map.set_cell(x, y, Config.TILE_FLOOR)
	
	top_left_corner -= Vector2.ONE * 10
	bottom_right_corner += Vector2.ONE * 10
	
	for x in range(top_left_corner.x + 1, bottom_right_corner.x):
		for y in range(top_left_corner.y + 1, bottom_right_corner.y):
			if map.get_cell(x, y) == TileMap.INVALID_CELL:
				map.set_cell(x, y, Config.TILE_STONE)
	
	var processedPoints = []
	
	for point_id in graph.get_points():
		processedPoints.push_back(point_id)
		var start_position = map.world_to_map(graph.get_point_position(point_id))
		for target_point_id in graph.get_point_connections(point_id):
			if processedPoints.find(target_point_id) != -1:
				continue
			var target_position = map.world_to_map(graph.get_point_position(target_point_id))
			var current_position = start_position
			var diff_vector = target_position - start_position
			var axis = ['x', 'y']
			if randi() % 2 == 0:
				axis = ['y', 'x']
			for single_axis in axis:
				while current_position[single_axis] != target_position[single_axis]:
					map.set_cell(current_position.x, current_position.y, Config.TILE_FLOOR)
					current_position[single_axis] += diff_vector.sign()[single_axis]
