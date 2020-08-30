extends Node2D

#var Dungeon_Scene : PackedScene = preload("res://Rooms/Dungeon.tscn")
var Player : PackedScene = preload("res://Actors/Player/Player.tscn")

export var loading_screen: NodePath

func _ready():	
	$LevelCreator.create_level(5)
	var player_spawn_point = find_node("PlayerSpawn", true, false)
	if player_spawn_point:
		var player = Player.instance()
		add_child(player)
		player.position = player_spawn_point.position


#func init_level(level):
#	var new_level = Dungeon_Scene.instance()
#	add_child(new_level)
#	move_child(new_level, 0)
#	Events.connect("level_loaded", self, "start_level", [level, new_level], CONNECT_ONESHOT)
#
#	new_level.generate_dungeon(level * 8, 0.5, 5, 10)
	
#func start_level(level, new_level: Node2D):
#	var loading_screen_node : Node2D = get_node(loading_screen)
#	loading_screen_node.visible = false
#	var player_spawn_point: Node2D = new_level.find_node("PlayerSpawnPoint", true, false)
#	if player_spawn_point:
#		var player = Player.instance()
#		new_level.add_child(player)
#		player.position = player_spawn_point.position
#	pass

#func _input(event):
#####################################################################
# Alter Switcheridoo Code
#####################################################################
#	if event.is_action_pressed("switch_player"):
#
#		var giver: Node
#		var recipient: Node
#
#		# Wer hat den Player node?
#		for switch_partner in switch_partner_nodes:
#			if is_instance_valid(switch_partner):
#				if switch_partner.is_a_parent_of(player_node):
#					giver = switch_partner
#				else:
#					recipient = switch_partner
#			else:
#				pass
#
#		if giver != null && recipient != null:
#			giver.remove_child(player_node)
#			recipient.add_child(player_node)			
