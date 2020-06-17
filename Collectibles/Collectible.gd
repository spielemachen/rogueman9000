extends Area2D

export var item_name: String

func _on_collect(body: Node2D):
	if body.has_node("Inventory"):
		body.get_node("Inventory").call("add", item_name)
		$Collider.queue_free()
		$AnimationPlayer.play("Blöb")
		
