extends Node2D

#references
onready var global = get_node("/root/Global")

#variables
#action key indexes are as follows : [UP, LEFT, DOWN, RIGHT, SPACE, PAUSE, RESET, SPARE]
export var key_index = 0
var key_added = false


func _process(delta):
	if key_added or global.key_overrides[key_index]:
		$TargetPositionSprite.modulate = get_parent().mod_target_added
	else:
		$TargetPositionSprite.modulate = get_parent().mod_target_removed
	$TargetPositionLabel.text = global.key_strings[key_index]
	global.action_key_targets[key_index] = global_position
