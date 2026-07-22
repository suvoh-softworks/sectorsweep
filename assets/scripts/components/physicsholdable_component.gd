class_name PhysicsHoldableComponent extends Node

#signal for when holding begins
signal being_held()
#signal for when holding is ended
signal end_held()
#signal for when thrown
signal thrown()

#not just player, since NPCs may at some point also hold objects
@export var distance_from_holder : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func physics_begin_holding() -> void:
	being_held.emit()
	print("holding!")
