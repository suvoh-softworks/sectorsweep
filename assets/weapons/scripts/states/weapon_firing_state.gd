extends WeaponState

func _on_firing_state_state_entered() -> void:
	if !weapon_controller:
		return
	#FIREEEEE
	weapon_controller.fire_weapon()
	

func _on_firing_state_state_processing(_delta: float) -> void:
	if !weapon_controller:
		return
	
	
	if Managers.weapon_manager.get_current_magazine() <= 0:
		weapon_controller.weapon_state_chart.send_event("onEmpty")
		return
	
	#keep firing if automatic and fire button held
	if weapon_controller.current_weapon.is_automatic:
		if Input.is_action_pressed("primary_fire"):
			if weapon_controller.can_fire():
				print("firing!")
				weapon_controller.fire_weapon()
		#fire button no longer held
		else:
			weapon_controller.weapon_state_chart.send_event("onIdle")
	else:
		#return to idle
		weapon_controller.weapon_state_chart.send_event("onIdle")
