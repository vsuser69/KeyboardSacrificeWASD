extends CanvasLayer

#references
onready var scene_manager = get_node("/root/BaseScene/SceneManager")


func _process(delta):
	for child in get_children():
		if scene_manager.game_state == scene_manager.states.MENU:
			child.hide()
		else:
			child.show()
	
	#update level label
	$LevelLabel.text = "Level " + str(scene_manager.current_level_index).pad_zeros(2)
