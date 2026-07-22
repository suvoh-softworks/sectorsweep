extends WeaponState


func _on_reloading_state_state_entered() -> void:
	if !weapon_controller:
		return
	weapon_controller.reload_weapon_magazine()


func _on_reloading_state_state_processing(_delta: float) -> void:
	if not weapon_controller.is_reloading():
		weapon_controller.weapon_state_chart.send_event("onIdle")
