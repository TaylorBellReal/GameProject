extends MeshInstance3D
#@export var object_scale: Vector2 = Vector2(1,1)
#@export var object_texture: Texture
#func _ready():
#	set_albedo_texture(object_texture,0)
#	self.mesh.size = object_scale


# Function to set a new albedo texture with specific settings
func set_albedo_texture(new_texture: Texture,type: int) -> void:
	# Ensure the mesh instance has a material
	if material_override == null:
		material_override = StandardMaterial3D.new()

	# Set the new albedo texture
	material_override.albedo_texture = new_texture

	# Enable transparency with alpha
	material_override.transparency = StandardMaterial3D.TRANSPARENCY_ALPHA

	#type 0 means not an indicator
	if (type == 0):
		# Y-billboard the texture
		material_override.billboard_mode = StandardMaterial3D.BILLBOARD_FIXED_Y
		material_override.billboard_keep_scale = false
	else: #means an indicator
		# Enable backlighting with hex code ff6666
		material_override.flags_unshaded = false
		material_override.backlight_enabled = true
		material_override.backlight = Color(1.0, 0.4, 0.4)  # Hex code ff6666
		material_override.billboard_mode = StandardMaterial3D.BILLBOARD_ENABLED
		material_override.billboard_keep_scale = false
		material_override.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
		

