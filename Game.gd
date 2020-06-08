extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var player_node_path: NodePath
export(Array, NodePath) var switch_partner_node_paths: Array

var player_node
var switch_partner_nodes: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	player_node = get_node(player_node_path)
	for node_path in switch_partner_node_paths:
		switch_partner_nodes.push_back(get_node(node_path))
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("switch_player"):
		
		var giver: Node
		var recipient: Node
		
		# Wer hat den Player node?
		for switch_partner in switch_partner_nodes:
			if switch_partner.is_a_parent_of(player_node):
				giver = switch_partner
			else:
				recipient = switch_partner
				
		if giver != null && recipient != null:
			giver.remove_child(player_node)
			recipient.add_child(player_node)			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
