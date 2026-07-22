class_name WeaponStateMachine extends Node

@export var weapon_controller : WeaponController

func _process(_delta: float) -> void:
	if weapon_controller:
		
		weapon_controller.weapon_state_chart.set_expression_property("Fire Cooldown:", weapon_controller.fire_rate_timer)
		weapon_controller.weapon_state_chart.set_expression_property("Reload Cooldown:", weapon_controller.reload_timer)
		weapon_controller.weapon_state_chart.set_expression_property("Magazine Ammo:", Managers.weapon_manager.get_current_magazine())
		weapon_controller.weapon_state_chart.set_expression_property("Reserve Ammo:", Managers.weapon_manager.get_current_reserve())
		weapon_controller.weapon_state_chart.set_expression_property("Current Weapon:", weapon_controller.current_weapon.weapon_name)
