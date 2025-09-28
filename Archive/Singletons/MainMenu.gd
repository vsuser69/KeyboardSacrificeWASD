extends Control

#signals
signal play
signal level_select
signal settings
signal credits
signal quit

#references
onready var menu_right = $MainMenuVBoxContainer/Split/MenuRight
onready var scene_manager = get_node("/root/BaseScene/SceneManager")


func _ready():
	#connect signals
	connect("play", scene_manager, "_on_play")
	connect("level_select", menu_right, "_on_level_select")
	connect("settings", menu_right, "_on_settings")
	connect("credits", menu_right, "_on_credits")
	connect("quit", scene_manager, "_on_quit")


func _on_PlayButton_button_up():
	emit_signal("play")
	_on_menu_button_select()


func _on_LevelSelectButton_button_up():
	emit_signal("level_select")
	_on_menu_button_select()


func _on_SettingsButton_button_up():
	emit_signal("settings")
	_on_menu_button_select()


func _on_CreditsButon_button_up():
	emit_signal("credits")
	_on_menu_button_select()


func _on_QuitButton_button_up():
	emit_signal("quit")
	_on_menu_button_select()


func _on_menu_button_rollover():
	get_parent().get_parent().get_node("MenuButtonRolloverAudioStreamPlayer").play()


func _on_menu_button_select():
	get_parent().get_parent().get_node("MenuButtonSelectAudioStreamPlayer").play()
