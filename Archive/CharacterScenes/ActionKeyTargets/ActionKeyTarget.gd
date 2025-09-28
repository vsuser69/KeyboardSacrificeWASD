extends Node2D

#signals
signal add_target
signal remove_target

#references
onready var target_positions = get_node("/root/BaseScene/UICanvasLayer/TargetPositions")

#variables
var key_string = ""
var target_position = Vector2.ZERO
var adding = true
var big_keys = ["Enter", "Space"]

#tween variables for position.x and position.y
var tween_duration = Vector2(1.0,1.0)
var tween_transition = Tween.TRANS_QUAD
var tween_ease = Tween.EASE_IN_OUT


func _ready():
	#connect signals
	connect("add_target", target_positions, "_on_add_target")
	connect("remove_target", target_positions, "_on_remove_target")
	
	#initialize sprite type
	if key_string in big_keys:
		$ActionKeyTargetSpaceSprite.show()
		$ActionKeyTargetSpaceLabel.show()
	else:
		$ActionKeyTargetSprite.show()
		$ActionKeyTargetLabel.show()
	
	if adding:
		$ActionKeyTargetSprite.modulate = get_parent().get_parent().get_parent().mod_color_player
		$ActionKeyTargetSpaceSprite.modulate = get_parent().get_parent().get_parent().mod_color_player
	else:
		$ActionKeyTargetSprite.modulate = get_parent().get_parent().get_parent().mod_color_free
		$ActionKeyTargetSpaceSprite.modulate = get_parent().get_parent().get_parent().mod_color_free
		emit_signal("remove_target", key_string)
		
	$ActionKeyTargetLabel.text = key_string
	$ActionKeyTargetSpaceLabel.text = key_string
	_on_move_to_target_position()


func _on_move_to_target_position():
	$ActionKeyTargetTween.interpolate_property(self, "global_position:x", global_position.x, target_position.x, tween_duration.x, tween_transition, tween_ease)
	$ActionKeyTargetTween.interpolate_property(self, "global_position:y", global_position.y, target_position.y, tween_duration.y, tween_transition, tween_ease)
	$ActionKeyTargetTween.start()
	yield($ActionKeyTargetTween, "tween_all_completed")
	
	if adding:
		emit_signal("add_target", key_string)
	else:
		emit_signal("remove_target", key_string)
		
	queue_free()
