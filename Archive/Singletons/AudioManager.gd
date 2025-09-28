extends Node


func _on_bus_volume_update(bus, volume):
	AudioServer.set_bus_volume_db(bus, volume)
	
	


func _on_bus_mute_update(bus, mute):
	AudioServer.set_bus_mute(bus, mute)
