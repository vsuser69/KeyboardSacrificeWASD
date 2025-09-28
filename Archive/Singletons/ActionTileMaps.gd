extends Node2D

#references
onready var global = get_node("/root/Global")

#highlight variables
export var active_mod = Color8(255,255,255,255)
export var inactive_mod = Color8(255,255,255,255)
export var disabled_mod = Color8(255,255,255,255)
export var goal_conditions_met_mod = Color8(255,255,255,255)

#action tile variables
onready var action_tilemaps = [$UpTileMap, $LeftTileMap, $DownTileMap, $RightTileMap, $SpaceTileMap, $PauseTileMap, $ResetTileMap, $EscapeTileMap]


func _process(delta):
	#highlight each tilemap based on current "player" or "pressed" status
	for i in range(len(action_tilemaps)):
		if global.key_player_status[i] or global.key_overrides[i]:
			if i == 7 and !false in global.win_condition:
				action_tilemaps[i].modulate = goal_conditions_met_mod
			else:
				if global.key_pressed_status[i]:
					action_tilemaps[i].modulate = active_mod
				else:
					action_tilemaps[i].modulate = inactive_mod
		else:
			action_tilemaps[i].modulate = disabled_mod
		
