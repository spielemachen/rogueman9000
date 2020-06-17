extends Area2D

export var is_open = false

func open():
	if !is_open:
		$Sprite.region_rect.position.x += 9
		remove_from_group("solid")
		collision_layer = 0
		is_open = true
	pass
	
func close():
	if is_open:
		$Sprite.region_rect.position.x -= 9
		add_to_group("solid")
		is_open = false
	pass
