class_name HealthComponent extends Node

signal health_changed(new_health: float, default_health: float)
signal damage_taken(amount: float, source: Node3D)
signal heal_taken(amount: float, overheal: float, source: Node3D)
signal entity_death()

#starting health of entity
@export var initial_health : float = 100
@export var max_health: float = 100.0
@export var max_overhealth : float = 200.0
@export var overhealth_decay_coe : float = 5.0 #health decay per second 
@export var start_max_health: bool = true

var current_health: float
var is_alive: bool = true

func _ready() -> void:
	if start_max_health:
		current_health = max_health
	else:
		current_health = initial_health

func take_damage(amount: float, source: Node3D = null) -> void:
	if !is_alive:
		return
		
	var abs_damage = abs(amount) #prevent negative damage that would heal
	
	#allow for negative health
	current_health = round(current_health - abs_damage)
	
	damage_taken.emit(abs_damage, source)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		_handle_entity_death()

func heal(amount: float, delta, source: Node3D = null) -> void:
	if !is_alive:
		return
	
	var abs_heal = abs(amount) #prevent negative healing that would damage
	
	#allow for overheal?
	current_health = round(current_health + abs_heal)
	var overheal = current_health - max_health
	
	if current_health > max_health:
		current_health -= overhealth_decay_coe * delta
	
	heal_taken.emit(abs_heal, overheal, source)
	health_changed.emit(current_health, max_health)

func _handle_entity_death() -> void:
	is_alive = false
	if current_health > 0:
		current_health = 0
	entity_death.emit()
