class_name PlayerStateMachine extends Node

@export var debug : bool = false
@export_category("References")
@export var player_controller : PlayerController
@export var player_flashlight : PlayerFlashlight
func _process(_delta: float) -> void:
	if player_controller:
		#player_controller.state_chart.set_expression_property("Player Velocity", player_controller.velocity)
		player_controller.state_chart.set_expression_property("Player Crouch Check", player_controller.crouch_check.is_colliding())
		player_controller.state_chart.set_expression_property("Step Handler Status",player_controller.step_handler.step_status)
		player_controller.state_chart.set_expression_property("Speed",player_controller.ground_speed)
		player_controller.state_chart.set_expression_property("Speed",player_controller.velocity)
		player_controller.state_chart.set_expression_property("Speed",player_controller.ground_speed)
		player_controller.state_chart.set_expression_property("Speed",player_controller.ground_speed)
