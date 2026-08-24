extends Node

var game_manager: GameManager
var weapon_manager : WeaponManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("find_managers")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func find_managers() -> void:
	game_manager = get_tree().get_first_node_in_group("game_manager")
	weapon_manager = get_tree().get_first_node_in_group("weapon_manager")
