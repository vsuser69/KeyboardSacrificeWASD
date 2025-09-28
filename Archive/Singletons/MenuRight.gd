extends TabContainer


func _on_level_select():
	current_tab = 0


func _on_settings():
	current_tab = 1


func _on_credits():
	current_tab = 2
