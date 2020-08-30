extends TileMap

func open_to(direction: Vector2):
	var position = Vector2(5, 5) + direction * Vector2(5, 5)
	set_cell(position.x, position.y, Config.TILE_FLOOR)
