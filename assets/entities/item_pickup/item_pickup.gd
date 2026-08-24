class_name ItemPickup extends Area3D
#General Script for item pickups of any type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_pickup)


#
func _on_pickup(body: Node3D) -> void:
	if not body is PlayerController:
		return
	
	if can_pickup(body):
		apply_pickup(body)
		queue_free()
	
func can_pickup(_player: PlayerController) -> bool:
	return true

func apply_pickup(_player: PlayerController) -> void:
	pass
