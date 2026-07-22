class_name WeaponPickup extends ItemPickup


@export var weapon_slot: int = 1
@export var weapon_resource: Weapon

func can_pickup(_player: PlayerController) -> bool:
	var weapon_data = Managers.weapon_manager.weapons[weapon_slot]
	
	#return true if weapon isn't unlocked or ammo is less than maximum allowed
	return not weapon_data.available or weapon_data.ammo_reserve < weapon_resource.max_ammo_reserve

func apply_pickup(_player: PlayerController) -> void:
	var weapon_data = Managers.weapon_manager.weapons[weapon_slot]
	
	#if weapon already available, give two magazines of ammo to player
	if weapon_data.available:
		weapon_data.ammo_magazine += (weapon_resource.max_ammo_magazine * 2)
		print(weapon_data.weapon_name + " Ammo Acquired." )
	else:
		Managers.weapon_manager.unlock_weapon(weapon_slot, weapon_resource)
		Managers.weapon_manager.switch_to_slot(weapon_slot)
		print(weapon_data.weapon_name + " Acquired.")
