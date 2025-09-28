extends Control

#signals
signal resume
signal skip
signal menu

#references
onready var scene_manager = get_node("/root/BaseScene/SceneManager")


func _ready():
	#connect signals
	connect("resume", scene_manager, "_on_resume")
	connect("skip", scene_manager, "_on_skip")
	connect("menu", scene_manager, "_on_menu")


func _process(delta):
	if is_visible_in_tree():
		if Input.is_action_just_released("resume"):
			_on_ResumeButton_button_up()
		elif Input.is_action_just_released("menu"):
			_on_MenuButton_button_up()
		elif Input.is_action_just_released("skip"):
			_on_SkipButton_button_up()


func _on_ResumeButton_button_up():
	emit_signal("resume")
	_on_menu_button_select()


func _on_MenuButton_button_up():
	emit_signal("menu")
	_on_menu_button_select()


func _on_SkipButton_button_up():
	emit_signal("skip")
	_on_menu_button_select()


func _on_menu_button_rollover():
	get_parent().get_parent().get_node("MenuButtonRolloverAudioStreamPlayer").play()


func _on_menu_button_select():
	get_parent().get_parent().get_node("MenuButtonSelectAudioStreamPlayer").play()
