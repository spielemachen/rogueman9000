extends Node

var grid_size = Vector2(8, 8)

var WALL_BOTTOM = Vector2(1, 0)
var WALL_TOP = Vector2(1, 0)
var WALL_LEFT = Vector2(0, 1)
var WALL_RIGHT = Vector2(3, 1)
var WALL_TOP_LEFT = Vector2.ZERO
var WALL_TOP_RIGHT = Vector2(3, 0)
var WALL_BOTTOM_LEFT = Vector2(0, 2)
var WALL_BOTTOM_RIGHT = Vector2(3, 2)
var FLOOR = Vector2(1,1)

var WALL_BOTTOM_LEFT_INNER = Vector2(0,3)
var WALL_BOTTOM_RIGHT_INNER = Vector2(1,3)
var WALL_TOP_LEFT_INNER = Vector2(2,3)
var WALL_TOP_RIGHT_INNER = Vector2(3,3)

var TILE_FLOOR = 1
var TILE_STONE = 0
