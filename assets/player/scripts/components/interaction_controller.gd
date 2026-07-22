class_name InteractionController extends Node

@export_category("References")
@export var interaction_point : Marker3D
@export var interaction_raycast : RayCast3D
@export var camera : Camera3D

var current_object : Object
var interacting_with_object : Node3D
var last_interacted_object : Node3D
var interaction_component : Node

func _process(delta: float) -> void:
	if Input.is_action_pressed("interact"):
		if current_object: #if currently interacting, prevframe
			interaction_component.interact_with()

		else: #if not interacting
			var potential_object: Object = interaction_raycast.get_collider()
			#Check I: interacting object is a node
			if potential_object and potential_object is Node:
				interaction_component = potential_object.get_node_or_null("InteractionComponent")
				print(interaction_component)
				#Check II: interacting object has int.comp.
				if interaction_component and interaction_component.can_interact:
					last_interacted_object = potential_object
					print("Interacting")
					current_object = potential_object
					interaction_component.interact_with_start(interaction_point, camera)
	if Input.is_action_just_released("interact") and current_object != null:
		if interaction_component:
				interaction_component.interact_with_end()
				print("stop holding")
				current_object = null
