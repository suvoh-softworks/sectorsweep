class_name PlayerController extends CharacterBody3D

@export var movement_debug : bool = false
@export_category("References")
#Get Player Camera
@export var camera: CameraController
@export var camera_effects : CameraEffects
#Get Player States
@export var state_chart : StateChart
#Get Player Collision
@export var standing_collision : CollisionShape3D
@export var crouching_collision : CollisionShape3D
@export var crouch_check : ShapeCast3D
@export var interaction_raycast : RayCast3D
@export var interaction_shapecast : ShapeCast3D
@export var step_handler : StepHandlerComponent
@export var player_flashlight : PlayerFlashlight
@export var weapon_controller : WeaponController
@export var interaction_controller : InteractionController
@export_category("Movement Attributes")
@export_group("Grounded Speed")
@export var walk_speed : float = 6.5
@export var sprint_speed : float = 10.0
@export var crouch_speed : float = 3.0
@export var ground_acceleration : float = 11.0
@export var ground_deceleration : float = 7.0
@export var ground_friction : float = 3.5
@export_group("Airborne Speed")
@export var air_cap : float = 0.86
@export var air_speed : float = 500.0
@export var air_acceleration : float = 800.0
@export_group("Swimming Speed")
@export var swim_speed : float = 6.0
@export var swim_up_speed : float = 8.0
@export_group("Jumping")
@export var jump_velocity : float = 4.9
@export var fall_velocity_threshold : float = -5.0

var _input_dir : Vector2 = Vector2.ZERO
var direction : Vector3 = Vector3.ZERO
var ground_speed : float = walk_speed
var current_fall_velocity : float = 0.0
var push_force : float = 10

var interacting_check : bool = false

#for stepup camera smoothing, attached to step_handler
var previous_velocity : Vector3

func _ready() -> void:
	pass

func _handle_ground_physics(delta) -> void:
	var speed_in_direction = self.velocity.dot(direction)
	#gradual increase in movement
	var groundspeed_add_until_cap = ground_speed - speed_in_direction
	if groundspeed_add_until_cap > 0:
		var accel_speed = ground_acceleration * delta * ground_speed
		accel_speed = min(accel_speed, groundspeed_add_until_cap)
		self.velocity += accel_speed * direction
	
	var control = max(self.velocity.length(), ground_deceleration)
	var drop = control * ground_friction * delta
	var new_speed = max(self.velocity.length() - drop, 0.0)
	if self.velocity.length() > 0:
		new_speed /= self.velocity.length()
	self.velocity *= new_speed

func _handle_air_physics(delta) -> void:
	self.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	
	var speed_in_direction = self.velocity.dot(direction)
	var airspeed_capped = min((air_speed * direction).length(), air_cap)
	
	var airspeed_add_until_capped = airspeed_capped - speed_in_direction
	if airspeed_add_until_capped > 0:
		var accel_speed = air_acceleration * air_speed * delta
		accel_speed = min(accel_speed, airspeed_add_until_capped)
		self.velocity += accel_speed * direction

func _physics_process(delta: float) -> void:
	previous_velocity = self.velocity
	#Traditional WASD movement
	_input_dir = Input.get_vector("move_left","move_right","move_forward","move_backward")
	direction = self.global_transform.basis * Vector3(_input_dir.x, 0, _input_dir.y).normalized()
	
	# Add the gravity.
	if is_on_floor():
		_handle_ground_physics(delta)
		
	if not is_on_floor():
		_handle_air_physics(delta)
	#base speed, changed with states
	#ground_speed = walk_speed
	
	
	
	#do physics checks
	move_and_slide()
	step_handler.handle_step_climbing()
	
	#enable debug to get current direction, velocity, and speed variables in console (per frame)
	
	#push objects colliding with player
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		var push_direction = -collision.get_normal()
		push_direction.y = 0
		
		if collider is RigidBody3D:
			collider.apply_impulse((push_direction * push_force), collision.get_position() - collider.global_position)


func update_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)
	
func stand() -> void:
	ground_speed = walk_speed
	standing_collision.disabled = false
	crouching_collision.disabled = true
	
func sprint() -> void:
	ground_speed = sprint_speed
	print("Sprinting!")
	
func crouch() -> void:
	ground_speed = crouch_speed
	standing_collision.disabled = true
	crouching_collision.disabled = false
	   
func walk() -> void:
	ground_speed = walk_speed
	
func jump() -> void:
	self.velocity.y += jump_velocity

func check_fall_speed() -> bool:
	if current_fall_velocity < fall_velocity_threshold:
		current_fall_velocity = 0.0
		return true
	else:
		current_fall_velocity = 0.0
		return false

func get_input_direction() -> Vector2:
	return _input_dir
