extends Control

#signals
signal next
signal menu

#references
onready var scene_manager = get_node("/root/BaseScene/SceneManager")


func _ready():
	#connect signals
	connect("next", scene_manager, "_on_next")
	connect("menu", scene_manager, "_on_menu")


func _process(delta):
	if is_visible_in_tree():
		if Input.is_action_just_released("next"):
			_on_NextButton_button_up()
		elif Input.is_action_just_released("menu"):
			_on_MenuButton_button_up()


func _on_MenuButton_button_up():
	emit_signal("menu")
	_on_menu_button_select()


func _on_NextButton_button_up():
	emit_signal("next")
	_on_menu_button_select()


func _on_menu_button_rollover():
	get_parent().get_parent().get_node("MenuButtonRolloverAudioStreamPlayer").play()


func _on_menu_button_select():
	get_parent().get_parent().get_node("MenuButtonSelectAudioStreamPlayer").play()
