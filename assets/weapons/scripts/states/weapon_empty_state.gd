extends WeaponState


func _on_empty_state_state_processing(_delta: float) -> void:
	
	if Managers.weapon_manager.get_current_magazine() > 0:
		weapon_controller.weapon_state_chart.send_event("onIdle")
		
	#check for empty magazine, then weapon 
	if Managers.weapon_manager.get_current_magazine() <= 0 and Managers.weapon_manager.get_current_reserve() > 0:
		weapon_controller.weapon_state_chart.send_event("onReloading")	
	


func _on_empty_state_state_entered() -> void:
	pass # Replace with function body.
