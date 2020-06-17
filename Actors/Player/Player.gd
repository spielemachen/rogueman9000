extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var map_path: NodePath

var parent: KinematicBody2D

var direction = Vector2.ZERO
var ray: RayCast2D

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	parent = get_parent()
	ray = parent.get_node("CollisionRayCast")

func _input(event):
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
		var movement = direction * Config.grid_size
		ray.cast_to = movement
		ray.force_raycast_update()
		if !ray.is_colliding():
			parent.position += movement
			print(parent.position)
		else:
			var collider = ray.get_collider()
			if collider is Area2D && collider.is_in_group("enemies"):
				get_tree().quit()

				

#func _physics_process(delta):
#	if direction != Vector2.ZERO:
#		parent.move_and_collide(map.map_to_world(direction))
#		direction = Vector2.ZERO
#		print(parent.position)

#		parent.position = map.map_to_world(map.world_to_map(parent.position) + pos_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
