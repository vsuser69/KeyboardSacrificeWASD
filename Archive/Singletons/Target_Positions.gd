extends Node2D

#references
onready var global = get_node("/root/Global")

#exports
export var mod_target_added = Color8(255,255,255,255)
export var mod_target_removed = Color8(255,255,255,255)


func _on_add_target(key_string):
	get_child(global.key_strings.find(key_string)).key_added = true


func _on_remove_target(key_string):
	get_child(global.key_strings.find(key_string)).key_added = false


func _on_reset_targets():
	#reset "key_added" each time level is loaded
	for child in get_children():
		child.key_added = false
