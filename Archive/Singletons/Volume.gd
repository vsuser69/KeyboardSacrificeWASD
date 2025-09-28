extends HBoxContainer

#signals
signal bus_volume_update
signal bus_mute_update

#references
onready var audio_manager = get_node("/root/AudioManager")

#exports
export var audio_bus = 0
export var volume_label = "Volume"


func _ready():
	#connect signals
	connect("bus_volume_update", audio_manager, "_on_bus_volume_update")
	connect("bus_mute_update", audio_manager, "_on_bus_mute_update")
	
	#initialize bus values
	emit_signal("bus_volume_update", audio_bus, $HSlider.value)
	emit_signal("bus_mute_update", audio_bus, $Button.pressed)
	
	#update label
	$Label.text = volume_label


func _on_HSlider_value_changed(value):
	emit_signal("bus_volume_update", audio_bus, value)
	
	#if effects bus, play test sound
	if audio_bus == 2:
		$AudioStreamPlayer.play()


func _on_Button_toggled(button_pressed):
	emit_signal("bus_mute_update", audio_bus, button_pressed)
	
	#update button text
	if button_pressed:
		$Button.text = "Unmute"
	else:
		$Button.text = "Mute"
