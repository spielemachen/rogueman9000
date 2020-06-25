extends Area2D

export var is_open = false
export var is_locked = true

func get_push_requirement(from):
	if is_locked:
		return "key"
	return null
	
func push(from):
	if !is_open:
		$Sprite.region_rect.position.x += 9
		remove_from_group("solid")
		is_open = true
		is_locked = false
	pass

func activate(from):
	if is_open:
		$Sprite.region_rect.position.x -= 9
		add_to_group("solid")
		is_open = false
	pass
