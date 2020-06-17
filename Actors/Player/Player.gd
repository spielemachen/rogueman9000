extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var map_path: NodePath

var parent: Area2D

var direction = Vector2.ZERO
var ray: RayCast2D
var inventory: Inventory

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	parent = get_parent()
	ray = parent.get_node("CollisionRayCast")
	inventory = parent.get_node_or_null("Inventory")

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
		var move_by = direction * Config.grid_size
		ray.cast_to = move_by
		ray.force_raycast_update()
		if !ray.is_colliding():
			parent.position += move_by
		else:
			_check_and_act_on_collider(move_by)
			
	if event.is_action_pressed("activate"):
		trigger_turn = true

#	if event.is_action_pressed("activate"):
#		trigger_turn = true
#		ray.force_raycast_update()
#		if ray.is_colliding():
#			var collider = ray.get_collider()
#			if collider.is_in_group("doors") && collider.has_method("close"):
#				collider.close()
				
				
	if trigger_turn:
		Events.emit_signal("player_turn_done")

func _check_and_act_on_collider(move_by):
	var collider = ray.get_collider()
	
	if !collider.is_in_group("solid"):
		parent.position += move_by
		
	if collider.is_in_group("enemies"):
		get_tree().quit()
		
	if collider.is_in_group("doors"):
		if inventory != null && inventory.has("key"):
			if collider.has_method("open"):
				collider.open()
				inventory.remove("key")
