class_name InteractionComponent extends Node

#begin interaction
signal interact_signal()

enum InteractionType {
	DEFAULT, #Default
	PHYSICS, #Physics items that can be moved by player
	DOOR, #Rigid doors
	BUTTON, #Buttons, levers, single use entities
	PICKUP #Pickup entities
}

@export var object_ref: Node3D
#only allow interaction once
@export var interaction_type : InteractionType = InteractionType.DEFAULT

var interaction_point : Marker3D
var player_camera : Camera3D
var can_interact : bool = true
var interacted_once : bool = false
var is_interacting : bool = false

func _ready() -> void:
	return

func interact_with_start(interact_point: Marker3D, camera: Camera3D) -> void:
	is_interacting = true
	match interaction_type:
		InteractionType.PHYSICS:
			interaction_point = interact_point
			player_camera = camera

func interact_with() -> void:
	if !can_interact:
		return
	match interaction_type:
		InteractionType.PHYSICS:
			_physics_interact()
		InteractionType.BUTTON:
			pass

func interact_with_end() -> void:
	is_interacting = false

#function for picking up physics objects, should be different to pushing a very heavy object
func _physics_interact() -> void:
	#object's position normalization
	if object_ref:
		var object_current_position: Vector3 = object_ref.global_transform.origin
		var interaction_point_position: Vector3 = interaction_point.global_transform.origin
		var position_between : Vector3 = interaction_point_position - object_current_position
		
		#object's rotation normalization
		var object_current_rotation: Vector3 = object_ref.global_rotation
		var interaction_point_rotation: Vector3 = Vector3(0, player_camera.global_rotation.y,0)
		var rotation_between : Vector3 = interaction_point_rotation - object_current_rotation
		
		var rigid_body: RigidBody3D = object_ref as RigidBody3D
		if RigidBody3D:
			rigid_body.set_linear_velocity(position_between * (5/rigid_body.mass))
			rigid_body.set_angular_velocity(rotation_between * (5/rigid_body.mass))

func _button_interact() -> void:
	return

func _door_interact() -> void:
	return

func _pickup_interact() -> void:
	return
