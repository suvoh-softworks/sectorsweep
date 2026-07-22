class_name Projectile extends Area3D

#How fast, what direction the projectile travels
var camera : Camera3D
var velocity : Vector3
var damage: float

func ready() -> void:
	body_entered.connect(_on_body_entered)
	
	get_tree().create_timer(10.0).timeout.connect(queue_free)
	
func _physics_process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var start_pos = global_position
	var end_pos = global_position + velocity * delta
	
	var query = PhysicsRayQueryParameters3D.create(start_pos, end_pos)
	var result = space_state.intersect_ray(query)
	
	if result:
		global_position = result.position
		_on_body_entered(result.collider)
		return
	global_position = end_pos
	
	
func setup(vel: Vector3, dmg: float) -> void:
	velocity = vel
	damage = dmg
	
#on the projectile hitbox making contact with a body
func _on_body_entered(body: Node3D) -> void:
	print("Projectile hit: ", body.name, " at ", global_position)
	_spawn_impact_marker(global_position)
	
	var health_component = body.get_node_or_null("HealthComponent")
	
	if health_component and health_component.has_method("take_damage"):
		health_component.take_damage(damage, owner)
	
	queue_free()

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
