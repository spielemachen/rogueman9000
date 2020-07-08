extends Node2D

var Room = preload("res://Rooms/Room.tscn")
var Player = preload("res://Actors/Player/Player.tscn")
var ROOM_AMOUNT = 20
var DELETE_RATE = 0.5
var MIN_SIZE = 5
var MAX_SIZE = 10

var graph: AStar2D
onready var map: TileMap = $Map 

func _ready():
	randomize()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		$Rooms.free()
		map.clear()
		graph = null
		var roomsContainer = Node.new()
		roomsContainer.name = 'Rooms'
		add_child(roomsContainer)
		for i in range(0, ROOM_AMOUNT):
			var room = Room.instance()
			var width = MIN_SIZE + randi() % (MAX_SIZE - MIN_SIZE)
			var height = MIN_SIZE + randi() % (MAX_SIZE - MIN_SIZE)
			$Rooms.add_child(room)
			room.init_room(Vector2.ZERO, Config.grid_size * Vector2(width, height))
		yield(get_tree().create_timer(1.5), 'timeout')
		
		var room_positions = []		
		for room in $Rooms.get_children():
			if randf() < DELETE_RATE:
				room.queue_free()
			else:
				room.mode = RigidBody2D.MODE_STATIC
				room_positions.push_back(room.position)
		graph = find_mst(room_positions)
		
	if event.is_action_pressed("ui_focus_next"):
		create_map()

func _process(delta):
	update()

func _draw():
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2), Color.red, false)
	pass
	
	if graph:
		for point in graph.get_points():
			for point_other in graph.get_point_connections(point):
				var pos1 = graph.get_point_position(point)
				var pos2 = graph.get_point_position(point_other)
				draw_line(pos1, pos2, Color.orange, 3, true)
		

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
	map.clear()

	for room in $Rooms.get_children():
		var left_top = map.world_to_map(room.position - room.size)
		var right_bottom = map.world_to_map(room.position + room.size)
		
		for x in range(left_top.x + 2, right_bottom.x - 1):
			map.set_cell(x, left_top.y + 1, 0, false, false, false, Config.WALL_TOP)
		for y in range(left_top.y + 2, right_bottom.y - 1):
			map.set_cell(right_bottom.x - 1, y, 0, false, false, false, Config.WALL_RIGHT)
		for y in range(left_top.y + 2, right_bottom.y - 1):
			map.set_cell(left_top.x + 1, y, 0, false, false, false, Config.WALL_LEFT)
		for x in range(left_top.x + 2, right_bottom.x - 1):
			map.set_cell(x, right_bottom.y - 1, 0, false, false, false, Config.WALL_BOTTOM)

		for x in range(left_top.x + 2, right_bottom.x - 1):
			for y in range(left_top.y + 2, right_bottom.y - 1):
				map.set_cell(x, y, 0, false, false, false, Config.FLOOR)

		map.set_cell(left_top.x + 1, left_top.y + 1, 0, false, false, false, Config.WALL_TOP_LEFT)
		map.set_cell(right_bottom.x - 1, left_top.y + 1, 0, false, false, false, Config.WALL_TOP_RIGHT)
		map.set_cell(left_top.x + 1, right_bottom.y - 1, 0, false, false, false, Config.WALL_BOTTOM_LEFT)
		map.set_cell(right_bottom.x - 1, right_bottom.y - 1, 0, false, false, false, Config.WALL_BOTTOM_RIGHT)

	if graph:
	
		for point_id in graph.get_points():
			for connected_point_id in graph.get_point_connections(point_id):
				var position1 = graph.get_point_position(point_id)
				var position2 = graph.get_point_position(connected_point_id)
				var current_position = map.world_to_map(position1)
				var position2_map = map.world_to_map(position2)
				var diff_vector = position2_map - current_position
	
				while position2_map.x != current_position.x:
					if map.get_cell_autotile_coord(current_position.x, current_position.y - 1) != Config.FLOOR:
						map.set_cell(current_position.x, current_position.y - 1, 0, false, false, false, Config.WALL_TOP)
					map.set_cell(current_position.x, current_position.y, 0, false, false, false, Config.FLOOR)
					if map.get_cell_autotile_coord(current_position.x, current_position.y + 1) != Config.FLOOR:
						map.set_cell(current_position.x, current_position.y + 1, 0, false, false, false, Config.WALL_BOTTOM)
					current_position.x += diff_vector.sign().x
	
				if map.get_cell_autotile_coord(current_position.x, current_position.y - 1) != Config.FLOOR:
					map.set_cell(current_position.x, current_position.y - 1, 0, false, false, false, Config.WALL_TOP)
				map.set_cell(current_position.x, current_position.y, 0, false, false, false, Config.FLOOR)
				if map.get_cell_autotile_coord(current_position.x, current_position.y + 1) != Config.FLOOR:
					map.set_cell(current_position.x, current_position.y + 1, 0, false, false, false, Config.WALL_BOTTOM)
				current_position.x += diff_vector.sign().x
	
				while position2_map.y != current_position.y:
					if map.get_cell_autotile_coord(current_position.x - 1, current_position.y) != Config.FLOOR:
						map.set_cell(current_position.x - 1, current_position.y, 0, false, false, false, Config.WALL_LEFT)
					map.set_cell(current_position.x, current_position.y, 0, false, false, false, Config.FLOOR)
					if map.get_cell_autotile_coord(current_position.x + 1, current_position.y) != Config.FLOOR:
						map.set_cell(current_position.x + 1, current_position.y, 0, false, false, false, Config.WALL_RIGHT)
					current_position.y += diff_vector.sign().y	
