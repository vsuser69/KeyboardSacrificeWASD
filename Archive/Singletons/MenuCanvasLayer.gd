extends CanvasLayer

#references
onready var scene_manager = get_node("/root/BaseScene/SceneManager")

#exports
export var mod_menu_color = Color8(255,255,255,255)
export var mod_pause_color = Color8(255,255,255,255)


func _process(delta):
	#set menu color
	if scene_manager.game_state == scene_manager.states.PAUSE or scene_manager.game_state == scene_manager.states.WIN:
		$MenuColorRect.modulate = mod_pause_color
	else:
		$MenuColorRect.modulate = mod_menu_color
	
	#set menu visibility
	if scene_manager.game_state == scene_manager.states.MENU:
		$MenuColorRect.show()
		$MainMenu.show()
		$PauseMenu.hide()
		$WinMenu.hide()
	elif scene_manager.game_state == scene_manager.states.PLAY:
		$MenuColorRect.hide()
		$MainMenu.hide()
		$PauseMenu.hide()
		$WinMenu.hide()
	elif scene_manager.game_state == scene_manager.states.PAUSE:
		$MenuColorRect.show()
		$MainMenu.hide()
		$PauseMenu.show()
		$WinMenu.hide()
	elif scene_manager.game_state == scene_manager.states.WIN:
		$MenuColorRect.show()
		$MainMenu.hide()
		$PauseMenu.hide()
		$WinMenu.show()
