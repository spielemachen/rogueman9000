class_name Inventory
extends Node

var items = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func add(item: String):
	items.append(item)
	_update_itemlist()
	
func has(item: String):
	return items.find(item) >= 0
	
func remove(item: String):
	var idx = items.find(item)
	if idx >= 0:
		items.remove(idx)
		_update_itemlist()

func _update_itemlist():
	print(items)
