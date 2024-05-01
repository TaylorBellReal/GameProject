extends RigidBody3D

var player_in_sight:bool = false
var uppies:bool = false
@export var object_name:String = "Pet House"
@export var held_sprite:Texture = preload("res://Sprites/PetRelated/UI/Sprites/pet_HouseB2_Sprite.png")
@export var default_scale = Vector2(1,1)
@export var default_position = Vector2(900,514)
@onready var PARENT = self
@export var PLAYER : Node
@export var PET: Node

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var impulse_vector = Vector3(1,1,1)
var launchForce = 5

func _physics_process(delta):
	# Add the forces manually ########################################################
	#self.velocity.y -= gravity * delta
	pass
	#apply_force()


func get_grabbed() -> void:
	PARENT.visible = false
	uppies = true

func drop(input) -> void:
	#Dont DO THIS CHANGE HOW GET LOCATION
	PhysicsServer3D.body_set_state(
	get_rid(),
	PhysicsServer3D.BODY_STATE_TRANSFORM,
	Transform3D.IDENTITY.translated(Vector3(input.x,PARENT.position.y,input.z)))
	
	PARENT.visible = true
	#print("dropped")
	uppies = false
	#shoot()
	if PET.mood == "angy":
		PET.thrown_fris = true
	launchObject()

func _ready():
	#set_freeze_mode(RigidBody3D.FREEZE_MODE_KINEMATIC)
	set_collision_layer(1) # Set your desired collision layer
	set_collision_mask(1)  # Set your desired collision mask

func shoot():
	if PLAYER:
		var direction = -PLAYER.global_transform.basis.z.normalized() # Assuming the player is facing in the negative z-axis direction
		var velocity = direction * 10 # Adjust the speed as needed
		apply_impulse(impulse_vector, velocity)

func launchObject():
	# Get the direction the player is facing
	var playerDirection = -PLAYER.global_transform.basis.z
	
	# Calculate the position in front of the player
	var spawnPosition = PLAYER.global_position + playerDirection * 1
	#PhysicsServer3D.body_set_state(get_rid(),PhysicsServer3D.BODY_STATE_TRANSFORM,Transform3D.IDENTITY.translated(spawnPosition))
	#self.get_child(0).get_child(0).position = spawnPosition

	# Apply force in the direction the player is facing
	var launchVector = playerDirection.normalized() * launchForce
	self.apply_central_impulse(launchVector)
