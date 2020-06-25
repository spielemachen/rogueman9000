extends Area2D

func push(from):
	if has_node('Player'):
		$Player.push(from)
	else:
		queue_free()
