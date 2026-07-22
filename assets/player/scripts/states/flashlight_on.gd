extends PlayerState

func _on_flashlight_on_state_processing(_delta: float) -> void:
	if Input.is_action_just_pressed("flashlight") and player_flashlight.is_flashlight_on:
		player_controller.state_chart.send_event("onFlashlightOff")

#this is kind of weird but keeps the flashlight from starting on in the FlashlightOff state
func _on_flashlight_on_state_exited() -> void:
	player_flashlight.toggle_player_flashlight()
