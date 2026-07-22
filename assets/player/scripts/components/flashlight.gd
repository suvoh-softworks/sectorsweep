class_name PlayerFlashlight extends SpotLight3D
@export var debug : bool = false
@export_category("References")
@export var player : PlayerController
@export_category("Flashlight Settings")
@export var enable_flashlight : bool = true
@export var enable_flicker : bool = true

var is_flashlight_on : bool = false

func toggle_player_flashlight() -> void:
	
	if enable_flashlight:
		if !visible:
			visible = true
			is_flashlight_on = true
		else:
			visible = false
			is_flashlight_on = false
		if debug:
			print("!!! Flashlight Touched! ", visible)
