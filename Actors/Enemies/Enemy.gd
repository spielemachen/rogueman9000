extends Actor

var direction = Vector2.ZERO

func _ready():
	Events.connect("player_turn_done", self, "turn")
	ray = $CollisionRayCast
	inventory = $Inventory
	actor_object = self
	randomize()
	
func push(from: Node):
	if has_node("Player"):
		$Player.push(from)
	else:
		if from.is_in_group("enemies"):
			print("LASS UNS KUSCHELN, SCHNUCKIIII!")
		if from.is_in_group("player"):
			print("DU BIST TOT!! MUAHAHAHAHAHAHAHAH!")
	
func turn():
	if has_node('Player'):
		return

	direction = Vector2.RIGHT

	match randi() % 8:
		0:
			direction = Vector2.RIGHT
		1:
			direction = Vector2.LEFT
		2:
			direction = Vector2.UP
		3:
			direction = Vector2.DOWN
	
	if direction != Vector2.ZERO:
		_move_in_direction(direction)
