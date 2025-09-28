extends Node2D

#signals
signal reset_targets
signal add_target
signal remove_target

#references
onready var global = get_node("/root/Global")
onready var target_positions = get_node("/root/BaseScene/UICanvasLayer/TargetPositions")


func _ready():
	#connect signals
	connect("reset_targets", target_positions, "_on_reset_targets")
	connect("add_target", target_positions, "_on_add_target")
	connect("remove_target", target_positions, "_on_remove_target")
	emit_signal("reset_targets")


func _on_add_target(key):
	var action_key_target_instance = preload("res://CharacterScenes/ActionKeyTargets/ActionKeyTarget.tscn").instance()
	action_key_target_instance.global_position = key.global_position
	action_key_target_instance.target_position = global.action_key_targets[global.key_strings.find(key.key_string)]
	action_key_target_instance.key_string = key.key_string
	action_key_target_instance.adding = true
	add_child(action_key_target_instance)
#	emit_signal("add_target", key.key_string)
	


func _on_remove_target(key):
	var action_key_target_instance = preload("res://CharacterScenes/ActionKeyTargets/ActionKeyTarget.tscn").instance()
	action_key_target_instance.global_position = global.action_key_targets[global.key_strings.find(key.key_string)]
	action_key_target_instance.target_position = key.global_position
	action_key_target_instance.key_string = key.key_string
	action_key_target_instance.adding = false
	add_child(action_key_target_instance)
#	emit_signal("remove_target", key.key_string)
