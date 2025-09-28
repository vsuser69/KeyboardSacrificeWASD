extends Node2D

#exports
export var level_quantity = 10
export var win_scene_path = ""

#menu/game state variables
enum states {MENU, PLAY, PAUSE, WIN}
var game_state = states.MENU

#level state variables
enum level_states {UNPLAYED, PLAYED, BEATEN}
var level_state_array = []
var current_level_index = 1
var next_unbeaten_level_index = 1

func _ready():
	#initialize level state array
	for i in range(level_quantity + 1):
		level_state_array.append(level_states.UNPLAYED)


func _on_load_scene(level_index):
	_on_clear_children()
	
	#load scene
	var scene = _on_return_scene_path(level_index)
	var scene_instance = load(scene).instance()
	add_child(scene_instance)
	
	#change game state
	game_state = states.PLAY
	
	#update current level
	current_level_index = level_index
	
	#change level state
	if level_state_array[current_level_index] == level_states.UNPLAYED:
		level_state_array[current_level_index] = level_states.PLAYED


func _on_return_scene_path(level_index):
	var level_string = str(level_index).pad_zeros(2)
	var scene_path = "res://GameScenes/Level" + level_string + ".tscn"
	return scene_path


func _on_play():
	_on_find_next_unbeaten_level()
	
	#load level
	_on_load_scene(next_unbeaten_level_index)
	
	#change game state to play
	game_state = states.PLAY


func _on_find_next_unbeaten_level():
	#find next unbeaten level
	next_unbeaten_level_index = 1
	for i in range(1,level_quantity+1):
		if level_state_array[i] == level_states.BEATEN:
			pass
		else:
			next_unbeaten_level_index = i
			break


func _on_pause():
	if game_state != states.WIN:
		get_tree().paused = true
		game_state = states.PAUSE


func _on_skip():
	get_tree().paused = false
	
	if current_level_index < level_quantity:
		_on_load_scene(current_level_index + 1)
	else:
		_on_load_scene(0)


func _on_win():
	get_tree().paused = true
	game_state = states.WIN
	level_state_array[current_level_index] = level_states.BEATEN
	
	#update next unbeaten level variable
	_on_find_next_unbeaten_level()
	
	#play win sound
	get_parent().get_node("GoalAudioStreamPlayer").play()


func _on_next():
	get_tree().paused = false
	
	if current_level_index < level_quantity:
		_on_load_scene(current_level_index + 1)
	else:
		_on_load_scene(0)


func _on_resume():
	get_tree().paused = false
	game_state = states.PLAY


func _on_reset():
	get_tree().paused = false
	_on_load_scene(current_level_index)


func _on_menu():
	_on_clear_children()
	get_tree().paused = false
	game_state = states.MENU


func _on_quit():
	get_tree().quit()


func _on_clear_children():
	#clear all children
	for child in get_children():
		child.queue_free()
