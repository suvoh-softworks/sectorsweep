extends PlayerState

#when Sprinting is active state, do:
func _on_sprinting_state_processing(_delta: float) -> void:
	if not Input.is_action_pressed("sprint"):
		player_controller.state_chart.send_event("onWalking")

#When entering Sprinting state, do:
func _on_sprinting_state_entered() -> void:
	if debug :
		print("Sprinting!")
	player_controller.sprint()
