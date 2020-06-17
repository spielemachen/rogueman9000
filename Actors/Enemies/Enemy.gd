extends Area2D

var ray: RayCast2D
var inventory: Inventory
var direction = Vector2.ZERO

func _ready():
	Events.connect("player_turn_done", self, "turn")
	ray = $CollisionRayCast
	inventory = $Inventory
	randomize()
	
func turn():
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
		var move_by = direction * Config.grid_size
		ray.cast_to = move_by
		ray.force_raycast_update()
		if !ray.is_colliding():
			position += move_by
		else:
			_check_and_act_on_collider(move_by)

func _check_and_act_on_collider(move_by):
	var collider = ray.get_collider()
	
	if !collider.is_in_group("solid"):
		position += move_by
		
	if collider.is_in_group("player"):
		get_tree().quit()
		
	if collider.is_in_group("doors"):
		if inventory != null && inventory.has("key"):
			if collider.has_method("open"):
				collider.open()
				inventory.remove("key")

