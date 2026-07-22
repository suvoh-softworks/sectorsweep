class_name AmmoPickup extends ItemPickup

@export var weapon_slot: int = 1
@export var ammo_amount: int = 20


func can_pickup(_player: PlayerController) -> bool:
	var weapon_data = Managers.weapon_manager.weapons[weapon_slot]
	#return true if weapon isn't unlocked or ammo is less than maximum allowed
	return not weapon_data.available or weapon_data.ammo_reserve < weapon_data.weapon.max_ammo_reserve

func apply_pickup(_player: PlayerController) -> void:
	var weapon_data = Managers.weapon_manager.weapons[weapon_slot]
	var ammo_reserve_max = weapon_data.weapon.max_ammo_reserve
	var ammo_reserve_current = weapon_data.ammo_reserve + ammo_amount
	
	#if weapon available, add to reserve without exceeding reserve maximum
	if weapon_data.available:
		if ammo_reserve_current > ammo_reserve_max:
			weapon_data.ammo_reserve = ammo_reserve_max
			print(weapon_data.weapon_name + " Ammo Acquired." )
		else:
			weapon_data.ammo_reserve = ammo_reserve_current
