@tool
#Directional light entity, similar enough to HL's func_spotlight
class_name SpotLight extends SpotLight3D

func _func_godot_apply_properties(entity_properties: Dictionary):
	#light settings
	light_color = entity_properties["color"] as Color
	light_energy = entity_properties["energy"] as float
	light_indirect_energy = entity_properties["indirect_energy"] as float
	shadow_enabled = entity_properties["shadow_enabled"] as bool
	distance_fade_enabled = entity_properties["lod_fade"] as bool
	#spotlight settings
	spot_range = entity_properties["spot_range"] as float
	spot_attenuation = entity_properties["spot_attenuation"] as float
	spot_angle = entity_properties["spot_angle"] as float
	spot_angle_attenuation = entity_properties["spot_angle_attenuation"] as float
