extends Node2D

func activate_doors(amount):
	var doors = get_children()
	
	while amount > 0:
		doors.pop_front()
		amount -= 1
		
	for door in doors:
		door.queue_free()
