extends Node2D

var Room = preload("res://Rooms/Room.tscn")
var Player = preload("res://Actors/Player/Player.tscn")
var ROOM_AMOUNT = 20
var DELETE_RATE = 0.4
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
		for i in range(1, ROOM_AMOUNT):
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
	print('create map');	
	for room in $Rooms.get_children():
		var left_top = map.world_to_map(room.position - room.size)
		var right_bottom = map.world_to_map(room.position + room.size)
		
		for x in range(left_top.x + 2, right_bottom.x - 1):
			map.set_cell(x, left_top.y + 1, 0, false, false, false, Vector2(1, 0))
		for y in range(left_top.y + 2, right_bottom.y - 1):
			map.set_cell(right_bottom.x - 1, y, 0, false, false, false, Vector2(3, 1))
		for y in range(left_top.y + 2, right_bottom.y - 1):
			map.set_cell(left_top.x + 1, y, 0, false, false, false, Vector2(0, 1))
		for x in range(left_top.x + 2, right_bottom.x - 1):
			map.set_cell(x, right_bottom.y - 1, 0, false, false, false, Vector2(1, 0))

		map.set_cell(left_top.x + 1, left_top.y + 1, 0, false, false, false, Vector2.ZERO)
		map.set_cell(right_bottom.x - 1, left_top.y + 1, 0, false, false, false, Vector2(3, 0))
		map.set_cell(left_top.x + 1, right_bottom.y - 1, 0, false, false, false, Vector2(0, 2))
		map.set_cell(right_bottom.x - 1, right_bottom.y - 1, 0, false, false, false, Vector2(3, 2))
		##map.set_cell(lefttop.x, lefttop.y, 1)
