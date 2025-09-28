extends Node2D

#references
onready var global = get_node("/root/Global")
onready var base_scene = get_node("/root/BaseScene")


func _process(delta):
	if global.space_action:
		_on_toggle_maps()


func _on_toggle_maps():
	#switch tilesets which will swap sprites and collision shapes
	var temp_tileset = $ToggleTileMapA.tile_set
	$ToggleTileMapA.tile_set = $ToggleTileMapB.tile_set
	$ToggleTileMapB.tile_set = temp_tileset
	
	#reset global variable
	global.space_action = false
	
	#play toggle tilemap sound
	base_scene.get_node("TilemapToggleStreamPlayer").play()
