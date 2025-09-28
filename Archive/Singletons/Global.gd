extends Node

#key mapping variables
#action key indexes are as follows : [UP, LEFT, DOWN, RIGHT, SPACE, PAUSE, RESET, SPARE]
var key_strings = ["", "", "", "", "", "", "", ""]
var key_overrides = [false,false,false,false,false,false,false,false]
var key_player_status = [0, 0, 0, 0, 0, 0, 0, 0]
var key_pressed_status = [0, 0, 0, 0, 0, 0, 0, 0]
var win_condition = [false,false,false,false,false,false,false,false]
var space_action = false

#raycast variables
#raycast values are as follows : 
#0 = clear, 1 = player key, 2 = free key, 3 = obstacle, 4 = player and free keys
#5 = player keys and obstacles, 6 = free keys and obstacles, 7 = player keys, free keys, and obstacles
var key_raycasts = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]

#action key target positions
var action_key_targets = [Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO]


func _process(delta):
#	print(key_pressed_status)
	pass
