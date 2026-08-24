class_name BreakableBottle extends RigidBody3D

@export var entity_name : String

func _on_health_component_entity_death() -> void:
	print(name, " Destroyed.")
	queue_free()


func _on_interactable_component_interact_start() -> void:
	var physics_holdable = get_node_or_null("PhysicsHoldableComponent")
	physics_holdable.physics_begin_holding()
