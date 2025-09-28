extends Button

#signals
signal load_scene

#references
onready var scene_manager = get_node("/root/BaseScene/SceneManager")

#exports
export var level_index = 1

#button variables
var scene_path = ""

func _ready():
	#connect signals
	connect("load_scene", scene_manager, "_on_load_scene")
	
	var level_string = str(level_index).pad_zeros(2)
	text = "Level " + level_string


func _process(delta):
	if scene_manager.level_state_array[level_index] == scene_manager.level_states.PLAYED or level_index == scene_manager.next_unbeaten_level_index:
		disabled = false
	elif scene_manager.level_state_array[level_index] == scene_manager.level_states.UNPLAYED:
		disabled = true
	elif scene_manager.level_state_array[level_index] == scene_manager.level_states.BEATEN:
		disabled = false


func _on_LevelButton_button_up():
	emit_signal("load_scene", level_index)
	$LevelButtonSelectAudioStreamPlayer.play()


func _on_LevelButton_mouse_entered():
	$LevelButtonRolloverAudioStreamPlayer.play()
