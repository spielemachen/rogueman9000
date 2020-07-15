extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Array, NodePath) var switch_partner_node_paths: Array

var player_node
var switch_partner_nodes: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for node_path in switch_partner_node_paths:
		var switcher_node = get_node(node_path)
		switch_partner_nodes.push_back(switcher_node)
		if switcher_node.has_node("Player"):
			player_node = switcher_node.get_node("Player")
		
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("switch_player"):
		
		var giver: Node
		var recipient: Node
		
		# Wer hat den Player node?
		for switch_partner in switch_partner_nodes:
			if is_instance_valid(switch_partner):
				if switch_partner.is_a_parent_of(player_node):
					giver = switch_partner
				else:
					recipient = switch_partner
			else:
				pass
		
		if giver != null && recipient != null:
			giver.remove_child(player_node)
			recipient.add_child(player_node)			

