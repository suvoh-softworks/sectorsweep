@tool
#Non-directional light entity, similar enough to HL's func_light
class_name Light extends OmniLight3D

func _func_godot_apply_properties(entity_properties: Dictionary):
#generic light attributes
	#color: RGB color of light
	light_color = entity_properties["color"] as Color
	#energy: intensity of light, does not affect range
	light_energy = entity_properties["energy"] as float
	#indirect_energy: light bouncing intensity
	light_indirect_energy = entity_properties["indirect_energy"] as float
	#cast_shadow: whether light casts a shadow
	shadow_enabled = entity_properties["cast_shadow"] as bool
	#lod_fade: whether light fades with distance, for LOD purposes
	distance_fade_enabled = entity_properties["lod_fade"] as bool 
#omni light attributes
	#light_range: range the light actually reaches, does not affect energy
	omni_range = entity_properties["light_range"] as float
	#light_attenuation: smooth ramping down of light, 0 gives sharp drop and 2 is realistic
	omni_attenuation = entity_properties["light_attenuation"] as float
