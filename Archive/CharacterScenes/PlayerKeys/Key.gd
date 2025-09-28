extends Area2D

#signals
signal start_tween
signal stop_tween
signal add_key
signal remove_key

#references
onready var action_tile_maps = get_node("/root/BaseScene/UICanvasLayer/ActionTileMaps")
onready var global = get_node("/root/Global")
onready var base_scene = get_node("/root/BaseScene")

#export variables
export var key_string = ""
export var can_drop_key = false

#key rayvast variables
var key_raycast_array = [0,0,0,0]

#tween variables
var tween_duration = 1.0
var tween_transition = Tween.TRANS_QUAD
var tween_ease_type = Tween.EASE_IN_OUT
var tween_delay = 0.0


func _ready():
	#connect signals
	connect("start_tween", self, "_on_start_tween", [], CONNECT_ONESHOT) #the first "stop tween" will be connected after the first "start tween" is signaled
	connect("add_key", get_parent().get_parent(), "_on_add_key")
	connect("remove_key", get_parent().get_parent(), "_on_remove_key")
	
	#set label text
	$KeyLabel.text = key_string


func _process(delta):
	if is_in_group("FreeKeys"):
		$KeyTextureProgress.tint_under = get_parent().get_parent().mod_color_free
		$KeyTextureProgress.tint_over = get_parent().get_parent().mod_color_free
		$KeyTextureProgress.tint_progress = Color8(255,255,255,255)
	if is_in_group("PlayerKeys"):
		$KeyTextureProgress.tint_under = Color8(255,255,255,255)
		$KeyTextureProgress.tint_over = get_parent().get_parent().mod_color_player
		$KeyTextureProgress.tint_progress = get_parent().get_parent().mod_color_player

func _physics_process(delta):
	#update raycast array
	key_raycast_array[0] = _update_raycast_array($KeyUpRayCast2D)
	key_raycast_array[1] = _update_raycast_array($KeyLeftRayCast2D)
	key_raycast_array[2] = _update_raycast_array($KeyDownRayCast2D)
	key_raycast_array[3] = _update_raycast_array($KeyRightUpRayCast2D)
	
	if is_in_group("PlayerKeys"):
		#update parent raycast disctionary with this key's raycast info
		global.key_raycasts[global.key_strings.find(key_string)] = key_raycast_array


func _update_raycast_array(raycast):
	var raycast_collider = raycast.get_collider()
	if raycast_collider:
		if raycast_collider.is_in_group("PlayerKeys"):
			return 1
		if raycast_collider.is_in_group("FreeKeys"):
			return 2
		if raycast_collider.is_in_group("Obstacles"):
			return 3
	else:
		return 0


func _unhandled_input(event):
	if event is InputEventKey:
		var event_key_string = OS.get_scancode_string(event.scancode)
		if event.is_pressed() and key_string == event_key_string and can_drop_key:
			emit_signal("start_tween")
		
		elif !event.is_pressed() and key_string == event_key_string and can_drop_key:
			emit_signal("stop_tween")


func _on_start_tween():
	$KeyTween.stop_all()
	connect("stop_tween", self, "_on_stop_tween", [], CONNECT_ONESHOT)
	if is_in_group("FreeKeys"):
		$KeyTween.interpolate_property($KeyTextureProgress, "value", $KeyTextureProgress.value, 360, tween_duration, tween_transition, tween_ease_type, tween_delay)
		$KeyTween.start()
	elif is_in_group("PlayerKeys"):
		$KeyTween.interpolate_property($KeyTextureProgress, "value", $KeyTextureProgress.value, 0, tween_duration, tween_transition, tween_ease_type, tween_delay)
		$KeyTween.start()

func _on_stop_tween():
	$KeyTween.stop_all()
	connect("start_tween", self, "_on_start_tween", [], CONNECT_ONESHOT)
	if is_in_group("FreeKeys"):
		$KeyTween.interpolate_property($KeyTextureProgress, "value", $KeyTextureProgress.value, 0, tween_duration, tween_transition, tween_ease_type, tween_delay)
		$KeyTween.start()
	elif is_in_group("PlayerKeys"):
		$KeyTween.interpolate_property($KeyTextureProgress, "value", $KeyTextureProgress.value, 360, tween_duration, tween_transition, tween_ease_type, tween_delay)
		$KeyTween.start()


func _on_KeyTween_tween_completed(object, key):
	if key == ":value":
		if $KeyTextureProgress.value == 360 and is_in_group("FreeKeys"):
			if 1 in key_raycast_array: #if a player key is nearby
				emit_signal("add_key", self)
				$KeyCPUParticles2D.modulate = get_parent().get_parent().mod_color_player
				$KeyCPUParticles2D.restart()
				base_scene.get_node("KeyReparentAudioStreamPlayer").play()
		elif $KeyTextureProgress.value == 0 and is_in_group("PlayerKeys") and get_parent().get_child_count() > 1:
			emit_signal("remove_key", self)
			$KeyCPUParticles2D.modulate = get_parent().get_parent().mod_color_free
			$KeyCPUParticles2D.restart()
			base_scene.get_node("KeyReparentAudioStreamPlayer").play()


func _on_Key_body_entered(body):
	if body.is_in_group("Red"):
		queue_free()
