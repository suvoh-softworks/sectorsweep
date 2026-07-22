class_name WeaponController extends Node

#for looking direction
@export var camera : Camera3D
#weapon currently selected
@export var weapon_model_parent : Node3D
@export var weapon_state_chart : StateChart

var current_weapon : Weapon
var current_weapon_model : Node3D
var emit_point : Node3D
var can_fire_next : bool = true
var fire_rate_timer : float = 0.0
var can_reload_next : bool = false
var reload_timer : float = 0.0

#spawn weapon model and instance ammo
func _ready() -> void:
	if current_weapon:
		spawn_weapon_model()

#handle fire rate through a decaying timer
func _process(delta: float) -> void:
	if fire_rate_timer > 0:
		fire_rate_timer -= delta
		if fire_rate_timer <= 0:
			can_fire_next = true
			fire_rate_timer = 0.0
	
	if reload_timer > 0:
		reload_timer -= delta
		
		if reload_timer <= 0:
			can_fire_next = true
			can_reload_next = false
			Managers.weapon_manager.reload_ammo_magazine(Managers.weapon_manager.current_slot)
			reload_timer = 0.0

#spawn the weapon's model
func spawn_weapon_model():
	if current_weapon_model:
		current_weapon_model.queue_free()
		
	if current_weapon.weapon_model:
		current_weapon_model = current_weapon.weapon_model.instantiate()
		weapon_model_parent.add_child(current_weapon_model)
		current_weapon_model.position = current_weapon.weapon_position


#check if player has weapon, and if that weapon has ammo
func can_fire() -> bool:
	if current_weapon:
		var weapon_data = Managers.weapon_manager.weapons[Managers.weapon_manager.current_slot]
		return weapon_data.ammo_magazine > 0 and can_fire_next
	else:
		return false



#actually fire the weapon
func fire_weapon() -> void:
	if can_fire():
		Managers.weapon_manager.use_ammo(Managers.weapon_manager.current_slot)
		camera.add_weapon_kick(current_weapon.recoil_pitch,current_weapon.recoil_yaw,current_weapon.recoil_roll)
		#print("Ammo Left: ", Managers.weapon_manager.get_current_magazine(), " / ", Managers.weapon_manager.get_current_reserve())
		
		#fire rate cooldown
		can_fire_next = false
		fire_rate_timer = 1.0 / current_weapon.fire_rate
		
		#FIRE WEAPON
		if current_weapon.is_hitscan:
			_perform_hitscan()
		else:
			_spawn_projectile()

#-- PERFORM FIRING OF WEAPON WHETHER HITSCAN OR PROJECTILE
#cast hitscan ray and get what it hits
#keep in mind the hitscan comes from the camera, not the weapon
func _perform_hitscan() -> void:
	if not camera:
		print("No camera assigned.")
		return
		
	#get current position of camera
	var space_state = camera.get_world_3d().direct_space_state #the 3D play space the camera is in
	var from = camera.global_position #actual camera position
	var accuracy_spread = (100.0 - current_weapon.accuracy) / 1000
	var forward = -camera.global_transform.basis.z #get firing direction, the player camera faces in the -Z direction
	
	for i in current_weapon.bullet_count:
		
		#base accuracy
		var accuracy_x = randf_range(-accuracy_spread, accuracy_spread)
		var accuracy_y = randf_range(-accuracy_spread, accuracy_spread)
		var direction = forward + Vector3(accuracy_x, accuracy_y, 0) * camera.global_transform.basis
		#accuracy including shot spread
		if current_weapon.bullet_count > 1:
			var spread_x = randf_range(-current_weapon.horizontal_spread, current_weapon.horizontal_spread)
			var spread_y = randf_range(-current_weapon.vertical_spread, current_weapon.vertical_spread)
			direction += Vector3(spread_x, spread_y, 0) * camera.global_transform.basis
		
		var to = from + direction * current_weapon.weapon_range #length of future raycast
		
		#fire a raycast
		var query = PhysicsRayQueryParameters3D.create(from, to) #build the raycast
		#query.collision_mask = 1 #use to restrict what collision masks can be hit, use later for shoot-through brushes
		var result = space_state.intersect_ray(query) #result of the raycast
		
		#check raycast result
		if result:
			#print("Hit: ", result.collider.name, " at ", result.position)
			_damage_target(result.collider)
			_push_target(result.collider, result.position)
			_spawn_impact_marker(result.position) #add impact 'puff' on impact position

func _spawn_impact_marker(position: Vector3) -> void:
	#build the impact marker visual
	var marker = MeshInstance3D.new() #can set to a scene
	var box = BoxMesh.new()
	box.size = Vector3(0.1, 0.1, 0.1)
	marker.mesh = box
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.MAGENTA
	marker.set_surface_override_material(0, material)
	
	#add the impact marker where the impact happened
	get_tree().current_scene.add_child(marker)
	marker.global_position = position
	
	#remove marker after 2 second timer
	get_tree().create_timer(2.0).timeout.connect(marker.queue_free)
	
func _spawn_projectile() -> void:
	if not current_weapon.projectile_scene:
		print("Error: No projectile scene assigned to Weapon")
		return
	
	if not camera:
		print("Error: No Camera Assigned")
		return
	
	#instance projectile
	var projectile = current_weapon.projectile_scene.instantiate() as Projectile
	get_tree().current_scene.add_child(projectile)
	
	#position from weapon model, eventually replace to be from weapon's emit point
	projectile.global_position = current_weapon_model.global_position
	
	#accuracy spread of projectile
	var accuracy_spread = (100.0 - current_weapon.accuracy) / 1000
	
	
	
	#calculate projectile direction and velocity
	var forward = -camera.global_transform.basis.z
	var accuracy_x = randf_range(-accuracy_spread, accuracy_spread)
	var accuracy_y = randf_range(-accuracy_spread, accuracy_spread)
	#apply inaccuracy to the forward vector
	var direction = forward + Vector3(accuracy_x, accuracy_y, 0) * camera.global_transform.basis
	
	var velocity = direction * current_weapon.projectile_speed
	
	projectile.setup(velocity, current_weapon.damage)

#CHANGE WEAPON
func switch_weapon(weapon_data: WeaponData) -> void:
	current_weapon = weapon_data.weapon
	
	if current_weapon_model:
		current_weapon_model.queue_free()
	
	spawn_weapon_model()
	#print(current_weapon.weapon_name)

#check if player has weapon, and if that weapon has ammo
func can_reload() -> bool:
	if current_weapon:
		var weapon_data = Managers.weapon_manager.weapons[Managers.weapon_manager.current_slot]
		return weapon_data.ammo_reserve > 0 and weapon_data.ammo_magazine < weapon_data.weapon.max_ammo_magazine
	else:
		return false

#Perform the reload, disallowing firing and recursive reloading
func reload_weapon_magazine() -> void:
	var slot = Managers.weapon_manager.current_slot
	
	can_fire_next = false
	can_reload_next = false
	reload_timer = Managers.weapon_manager.weapons[slot].weapon.reload_speed
	

func has_ammo_magazine() -> bool:
	var weapon_data = Managers.weapon_manager.weapons[Managers.weapon_manager.current_slot]
	return weapon_data.ammo_magazine > 0

func has_ammo_reserve() -> bool:
	var weapon_data = Managers.weapon_manager.weapons[Managers.weapon_manager.current_slot]
	return weapon_data.ammo_reserve > 0

func is_reloading() -> bool:
	return reload_timer > 0

func _damage_target(target: Node3D) -> void:
	var health_component : Node = target.get_node_or_null("HealthComponent")
	
	if health_component and health_component.has_method("take_damage"):
		health_component.take_damage(current_weapon.damage, owner)

#make physics objects react to being hit
func _push_target(target: Node3D, hit_position: Vector3) -> void:
	print("pushing!")
	if target is RigidBody3D:
		target.apply_impulse(((hit_position - target.global_position * -1) * (10 * current_weapon.damage / target.mass)), (hit_position - target.global_position) )
