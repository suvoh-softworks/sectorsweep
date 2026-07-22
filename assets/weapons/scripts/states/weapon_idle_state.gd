extends WeaponState

func _on_idle_state_state_processing(_delta: float) -> void:
	if not weapon_controller:
		return
	
	if Input.is_action_just_pressed("primary_fire") and weapon_controller.can_fire():
		weapon_controller.weapon_state_chart.send_event("onFiring")

	if !weapon_controller.has_ammo_magazine() and weapon_controller.has_ammo_reserve():
		weapon_controller.weapon_state_chart.send_event("onReloading")	

	#check for reload key, mag not full, have reserve ammo
	if Input.is_action_just_pressed("reload") and Managers.weapon_manager.get_current_magazine() < Managers.weapon_manager.get_max_magazine() and weapon_controller.has_ammo_reserve():
		weapon_controller.weapon_state_chart.send_event("onReloading")	

	if Managers.weapon_manager.get_current_magazine() <= 0:
		weapon_controller.weapon_state_chart.send_event("onEmpty")
