extends Node2D

#signals
signal add_target
signal remove_target
signal add_initial_targets

#references
onready var global = get_node("/root/Global")

#mod color variables
export var mod_color_player = Color8(255,255,255,255)
export var mod_color_free = Color8(255,255,255,255)
export var mod_color_goal = Color8(255,255,255,255)
export var mod_color_goal_outline = Color8(255,255,255,255)
export var mod_color_red = Color8(255,255,255,255)


func _ready():
	#connect signals
	connect("add_target", $AKTCanvasLayer/ActionKeyTargets, "_on_add_target")
	connect("remove_target", $AKTCanvasLayer/ActionKeyTargets, "_on_remove_target")
	connect("add_initial_targets", self, "_on_add_initial_targets", [], CONNECT_ONESHOT)


func _process(delta):
	if !Vector2.ZERO in global.action_key_targets:
		emit_signal("add_initial_targets")


func _on_add_initial_targets():
	for i in range(len($PlayerKeys.get_children())):
		emit_signal("add_target", $PlayerKeys.get_child(i))


func _on_add_key(area):
	#store area's global position
	var area_position = area.get_global_position()
	
	#reparent area
	$FreeKeys.remove_child(area)
	$PlayerKeys.add_child(area)
	
	#update area's global position
	area.set_global_position(area_position)
	
	#update area's groups
	area.remove_from_group("FreeKeys")
	area.add_to_group("PlayerKeys")
	
	#update player key's "just added key string" to hold the next movement
	$PlayerKeys.just_added_key_string = area.key_string
	
	#update global key player status
	global.key_player_status[$PlayerKeys.key_strings.find(area.key_string)] = 1
	
	#add key target
	emit_signal("add_target", area)


func _on_remove_key(area):
	#store area's global position
	var area_position = area.get_global_position()
	
	#reparent area
	$PlayerKeys.remove_child(area)
	$FreeKeys.add_child(area)
	
	#update area's global position
	area.set_global_position(area_position)
	
	#update area's groups
	area.remove_from_group("PlayerKeys")
	area.add_to_group("FreeKeys")
	
	#update global key player status
	global.key_player_status[$PlayerKeys.key_strings.find(area.key_string)] = 0
	
	#remove key target
	emit_signal("remove_target", area)
