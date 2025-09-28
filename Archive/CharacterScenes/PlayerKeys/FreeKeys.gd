extends Node2D


func _ready():
	#put all child nodes in "PlayerKeys" group
	for i in range(len(get_children())):
		get_child(i).add_to_group("FreeKeys")
		get_child(i).get_node("KeyTextureProgress").value = 0
	
