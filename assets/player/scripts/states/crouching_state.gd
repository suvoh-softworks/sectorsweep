extends PlayerState

func _on_crouching_state_processing(delta: float) -> void:
	player_controller.camera.update_camera_height(delta, -1)
	
	if not Input.is_action_pressed("crouch") and not player_controller.crouch_check.is_colliding():
		player_controller.state_chart.send_event("onStanding")

func _on_crouching_state_entered() -> void:
	if debug :
		print("Crouching!")
	player_controller.crouch()
