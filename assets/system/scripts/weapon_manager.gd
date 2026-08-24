class_name WeaponManager extends Node

@export var weapons : Dictionary[int, WeaponData] = {}
@export var player : PlayerController


var current_slot : int = 1

func _ready() -> void:
	add_to_group("weapon_manager")

	#automatically build the weapon row keysmaps
	for i in range(1, 10):
		var action_name = "weapon_" + str(i)
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
			var event = InputEventKey.new()
			event.keycode = KEY_1 + (i - 1)
			InputMap.action_add_event(action_name, event)
	call_deferred("initialize_starting_weapon")

func _unhandled_input(event: InputEvent) -> void:
	for i in range(1, 10):
		if event.is_action_pressed("weapon_" + str(i)):
			switch_to_slot(i)

#switch to selected slot and clear any reloads or firing penalties
func switch_to_slot(slot: int) -> void:
	var weapon_data = weapons.get(slot)
	
	if weapon_data and weapon_data.available:
		var weapon_controller = player.weapon_controller
		current_slot = slot
		weapon_controller.switch_weapon(weapon_data)
		if weapon_data.ammo_magazine > 0:
			weapon_controller.fire_rate_timer = 0
			weapon_controller.can_fire_next = true
		weapon_controller.reload_timer = 0
		weapon_controller.can_reload_next = true

func use_ammo(slot: int, amount: int = 1) -> void:
	if slot in weapons:
		weapons[slot].ammo_magazine = max(0, weapons[slot].ammo_magazine - amount)

func reload_ammo_magazine(slot: int) -> void:
	print("begin ammo change")
	if slot in weapons and weapons[slot].ammo_reserve > 0:
		#add up reserve and remainder in magazine
		var ammo_remaining = weapons[slot].ammo_reserve + weapons[slot].ammo_magazine
		if ammo_remaining < weapons[slot].weapon.max_ammo_magazine:
		#subtract from reserve, adding back whats left in magazine
			weapons[slot].ammo_reserve = 0
			weapons[slot].ammo_magazine = ammo_remaining
		else:
			weapons[slot].ammo_reserve -= (weapons[slot].weapon.max_ammo_magazine - weapons[slot].ammo_magazine)
			weapons[slot].ammo_magazine = weapons[slot].weapon.max_ammo_magazine
	print("end ammo change")

func get_current_magazine() -> int:
	return weapons[current_slot].ammo_magazine

func get_current_reserve() -> int:
	return weapons[current_slot].ammo_reserve

func get_max_magazine() -> int:
	return weapons[current_slot].weapon.max_ammo_magazine

func initialize_starting_weapon() -> void:
	for slot in range(1, 10):
		if weapons.has(slot) and weapons[slot].available:
			switch_to_slot(slot)
			return

func unlock_weapon(slot: int, weapon: Weapon) -> void:
	weapons[slot].weapon = weapon
	weapons[slot].available = true
	weapons[slot].ammo_magazine = weapon.max_ammo_magazine
	weapons[slot].ammo_reserve = weapon.max_ammo_magazine
