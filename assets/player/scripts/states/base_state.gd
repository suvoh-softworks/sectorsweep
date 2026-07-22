#BASE or PLAYER State
class_name PlayerState extends Node

#enable debug to print current player state in console
@export var debug : bool = false
var player_controller : PlayerController
var player_flashlight : PlayerFlashlight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if %PlayerStateMachine and %PlayerStateMachine is PlayerStateMachine:
		player_controller = %PlayerStateMachine.player_controller
		player_flashlight = %PlayerStateMachine.player_flashlight
