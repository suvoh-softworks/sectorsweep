@tool
class_name TriggerVolume extends Node

@export var targets : Array[String] = []
@export var trigger_once : bool = false
@export var trigger_on_exit : bool = false
@export var delay : float = 0.0

var has_triggered : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
