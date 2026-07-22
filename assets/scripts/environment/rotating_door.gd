@tool
#Rotating brush Entity, can be used for more than doors tbqh 
class_name RotatingDoor extends AnimatableBody3D

#angle to rotate to, degrees
@export var rotate_angle : float = 90.0
#time to swing to end angle, seconds
@export var swing_time : float = 3.0
#direction to swing in
@export var swing_direction : Vector3 =  Vector3.ZERO
#point on which the brush will rotate

var start_angle : Vector3 = Vector3.ZERO
var end_angle : Vector3 = Vector3.ZERO
var door_tween : Tween

func _func_godot_apply_properties(entity_properties: Dictionary):
	rotate_angle = entity_properties["rotate_angle"] as float
	swing_time = entity_properties["swing_time"] as float
	swing_direction = entity_properties["swing_direction"] as Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		start_angle = global_rotation
		end_angle = start_angle + (swing_direction.normalized() * rotate_angle)

func _start_rotation() -> void:
	door_tween = create_tween()
	door_tween.set_loops()
	door_tween.tween_property(self, "global_rotation", end_angle, swing_time)
	door_tween.tween_property(self, "global_rotation", start_angle, swing_time)
