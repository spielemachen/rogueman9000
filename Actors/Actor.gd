class_name Actor
extends Node2D

var inventory: Inventory
var ray: RayCast2D
var actor_object: Node2D

func _check_and_call_collider_method(collider: Node, method_name):
	if collider.has_method(method_name):
		var sufficient_conditions = false
		var requirement_method_name = "get_"+method_name+"_requirement"
		if !collider.has_method(requirement_method_name):
			sufficient_conditions = true
		else:
			var precon = collider.call(requirement_method_name, self)
			if precon == null:
				sufficient_conditions = true
			else: 
				if inventory != null && inventory.has(precon):
					inventory.remove(precon)
					sufficient_conditions = true
		if sufficient_conditions:
			collider.call(method_name, self)

func _check_and_act_on_collider(move_by):
	var collider = _get_collider()

	if collider == null || !collider.is_in_group("solid"):
		actor_object.position += move_by
		
	if collider != null:
		_check_and_call_collider_method(collider, "push")

func _get_collider():
	var collider = ray.get_collider()
	var ignored_colliders = []
	while collider != null && collider.position == actor_object.position:
		ray.add_exception(collider)
		ignored_colliders.push_back(collider)
		ray.force_raycast_update()
		collider = ray.get_collider()
		
	for ignored_collider in ignored_colliders:
		ray.remove_exception(ignored_collider)
	
	return collider

func _move_in_direction(direction: Vector2):
		var move_by = direction * Config.grid_size
		ray.cast_to = move_by
		ray.force_raycast_update()
		if !ray.is_colliding():
			actor_object.position += move_by
			actor_object.force_update_transform()
		else:
			_check_and_act_on_collider(move_by)
