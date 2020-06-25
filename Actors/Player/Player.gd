extends Actor


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var map_path: NodePath

var parent: Area2D

var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	actor_object = get_parent()
	ray = actor_object.get_node("CollisionRayCast")
	inventory = actor_object.get_node_or_null("Inventory")

func _input(event):
	var trigger_turn = false
	
	direction = Vector2.ZERO

	if event.is_action_pressed("ui_left"):
		direction = Vector2.LEFT;
	if event.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT;
	if event.is_action_pressed("ui_up"):
		direction = Vector2.UP;
	if event.is_action_pressed("ui_down"):
		direction = Vector2.DOWN;
	
	if direction != Vector2.ZERO:
		trigger_turn = true
		_move_in_direction(direction)
	else:
		if event.is_action_pressed("activate"):
			trigger_turn = true
			ray.force_raycast_update()
			var collider = _get_collider()
			if collider != null:
				_check_and_call_collider_method(collider, "activate")
				
	if trigger_turn:
		Events.emit_signal("player_turn_done")


func push(from):
	print("DER BÖSE EMEMY HAT MICH GEPUSHT!!! AAAAAAAAAH!")
