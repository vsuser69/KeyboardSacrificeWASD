extends Node2D

#signals
signal load_scene
signal move_to_target
signal pause
signal reset
signal win

#references
onready var action_tile_maps = get_node("/root/BaseScene/UICanvasLayer/ActionTileMaps")
onready var global = get_node("/root/Global")
onready var scene_manager = get_node("/root/BaseScene/SceneManager")
onready var move_target = get_parent().get_node("PlayerKeysMoveTarget")
onready var base_scene = get_node("/root/BaseScene")

#exports
export var key_strings = ["W", "A", "S", "D", "Space", "P", "R", "Enter"]
export var key_overrides = [false,false,false,false,false,false,false,false]

#player movement variables
var world_cell_size = Vector2(32,32)
var just_added_key_string = ""


func _ready():
	#connect signals
	connect("load_scene", scene_manager, "_on_load_scene")
	connect("move_to_target", self, "_on_move_to_target")
	connect("pause", scene_manager, "_on_pause")
	connect("reset", scene_manager, "_on_reset")
	connect("win", scene_manager, "_on_win")
	
	#initialize key map for player actions
	global.key_strings = key_strings
	global.key_overrides = key_overrides
	
	#initialize global player key status variables
	global.key_player_status = [0,0,0,0,0,0,0,0]
	
	#initialize global win status
	global.win_condition = [true,true,true,true,true,true,true,true]
	for i in range(get_parent().get_node("GoalKeyCanvasLayer/GoalKeys").get_child_count()):
		var goal_key = get_parent().get_node("GoalKeyCanvasLayer/GoalKeys").get_child(i)
		global.win_condition[global.key_strings.find(goal_key.key_string)] = false
	
	#put all child nodes in "PlayerKeys" group
	for i in range(len(get_children())):
		get_child(i).add_to_group("PlayerKeys")
		get_child(i).get_node("KeyTextureProgress").value = 360
		
		var child_key_string = get_child(i).key_string
		if child_key_string in key_strings:
			global.key_player_status[key_strings.find(child_key_string)] = 1


func _process(delta):
	if get_child_count() < 1:
		emit_signal("reset")


func _unhandled_input(event):
	if event is InputEventKey:
		var key_string = OS.get_scancode_string(event.scancode)
		for i in range(len(key_strings)):
			#set action_status bit for given key_string
			if key_string == key_strings[i]:
				if event.is_pressed():
					global.key_pressed_status[i] = 1
				else:
					global.key_pressed_status[i] = 0
		
		if !event.is_pressed():
			_on_key_released(key_string)


func _on_key_released(key_string):
	if key_string == just_added_key_string:
		just_added_key_string = ""
	else:
		#check if key string is in children
		var key_string_match = false
		for child in get_children():
			if key_string == child.key_string:
				key_string_match = true
				break
				
		if key_string_match or key_overrides[key_strings.find(key_string)]:
			#play action sound
			base_scene.get_node("ActionKeyAudioStreamPlayer").play()
			
			#check if key string is mapped to any actions
			if key_string == key_strings[0] and !_key_raycasts_check(key_string, 0, [2,3,4,5,6,7]):
				move_target.global_position.y -= world_cell_size.y
				emit_signal("move_to_target")
			elif key_string == key_strings[1] and !_key_raycasts_check(key_string, 1, [2,3,4,5,6,7]):
				move_target.global_position.x -= world_cell_size.x
				emit_signal("move_to_target")
			elif key_string == key_strings[2] and !_key_raycasts_check(key_string, 2, [2,3,4,5,6,7]):
				move_target.global_position.y += world_cell_size.y
				emit_signal("move_to_target")
			elif key_string == key_strings[3] and !_key_raycasts_check(key_string, 3, [2,3,4,5,6,7]):
				move_target.global_position.x += world_cell_size.x
				emit_signal("move_to_target")
			elif key_string == key_strings[4]:
				global.space_action = true
			elif key_string == key_strings[5]:
				emit_signal("pause")
			elif key_string == key_strings[6]:
				emit_signal("reset")
			elif key_string == key_strings[7] and !false in global.win_condition:
				emit_signal("win")
		else:
			base_scene.get_node("ActionFailAudioStreamPlayer").play()


#returns that certain values are in the checked index
func _key_raycasts_check(key_string, check_index, check_for_vals):
	var val_found = false
	for i in range(len(get_children())):
		if global.key_raycasts[global.key_strings.find(get_child(i).key_string)][check_index] in check_for_vals:
			val_found = true
	return val_found


func _on_move_to_target():
	var tween = move_target.get_node("PlayerKeysMoveTargetTween")
	tween.interpolate_property(self, "global_position",
		global_position,
		move_target.global_position,
		.25,
		Tween.TRANS_QUINT,
		Tween.EASE_OUT)
	
	tween.start()
