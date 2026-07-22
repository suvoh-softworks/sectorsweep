class_name Weapon extends Resource
#All player weapons inherit from this resource
@export_category("Classification")
@export var weapon_name : String = "Pistol"
@export_category("Damage")
@export var damage : float = 25.0
@export_category("Ammo")
@export var max_ammo_magazine : int = 10
@export var max_ammo_reserve : int = 190
@export var reload_speed : float = 3.0
@export_category("Accuracy Settings")
#base accuracy, before anything else is taken into account
@export_range(0, 100) var accuracy: int = 100
#multishot spread applied after accuracy, keep the numbers low unless you want a DOOM 3 shotgun
@export var horizontal_spread : float = 0.075
@export var vertical_spread : float = 0.05
@export_category("Recoil Settings")
@export var recoil_pitch : float = 1.0
@export var recoil_yaw : float = 1.0 #vertical recoil
@export var recoil_roll : float = 1.0 #horizontal recoil
@export_category("Hitscan/Projectile  Settings")
@export var projectile_speed : float = 75.0
@export var weapon_range : float = 200.0
#generally weapons will be made projectile, but where hitscan is needed it will be furnished
@export var is_hitscan : bool = true
#rate of fire (per second)
@export var fire_rate : float = 5
@export var is_automatic : bool = false
#amount of scans/projectiles per firing
@export var bullet_count: int
@export_category("Model and Visuals")
@export var weapon_model : PackedScene
@export var projectile_scene : PackedScene
@export var emit_point : Vector3 = Vector3(0.3, -0.3, 0.32)
#relative to player camera
@export var weapon_position : Vector3 = Vector3(0.3, -0.3, -0.32)
