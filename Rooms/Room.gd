extends RigidBody2D

var size

func init_room(pos: Vector2, extents: Vector2):
	size = extents
	position = pos
	var shape = RectangleShape2D.new()
	shape.extents = extents
	$CollisionShape2D.shape = shape
	
