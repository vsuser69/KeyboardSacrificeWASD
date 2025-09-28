extends Area2D

#signals
signal goal_highlight

#references
onready var global = get_node("/root/Global")

#variables
export var key_string = ""
var goal_entered = false
var current_area = Area2D.new()

func _ready():
	#connect signals
	connect("goal_highlight", self, "_on_goal_highlight", [], CONNECT_ONESHOT)
	
	$GoalKeySprite.modulate = get_parent().get_parent().get_parent().mod_color_goal
	$OutlineSprite.modulate = get_parent().get_parent().get_parent().mod_color_goal_outline
	$GoalKeyLabel.text = key_string


func _process(delta):
	if goal_entered and _on_area_position_match(current_area):
		global.win_condition[global.key_strings.find(key_string)] = true
		$OutlineSprite.show()
		
		#play goal highlight sound
		emit_signal("goal_highlight")
		
	else:
		global.win_condition[global.key_strings.find(key_string)] = false
		$OutlineSprite.hide()
		
		#reconnect goal highlight signal
		connect("goal_highlight", self, "_on_goal_highlight", [], CONNECT_ONESHOT)


func _on_area_position_match(area):
	return global_position == area.global_position


func _on_GoalKey_area_entered(area):
	if area.is_in_group("PlayerKeys") and area.key_string == key_string:
		goal_entered = true
		current_area = area


func _on_GoalKey_area_exited(area):
	if area.is_in_group("PlayerKeys") and area.key_string == key_string:
		goal_entered = false


func _on_goal_highlight():
	$AudioStreamPlayer.play()
