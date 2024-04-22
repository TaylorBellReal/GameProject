extends StaticBody3D

var player_in_sight:bool = false
var uppies:bool = false
@export var object_name:String = "Pet House"
@export var held_sprite:Texture = preload("res://Sprites/PetRelated/UI/Sprites/pet_HouseB2_Sprite.png")
@export var default_scale = Vector2(1,1)
@export var default_position = Vector2(900,514)
@onready var PARENT = self.get_parent()
# Called when the node enters the scene tree for the first time.

func get_grabbed() -> void:
	PARENT.visible = false
	uppies = true

func drop(input) -> void:
	PARENT.position = Vector3(input.x,PARENT.position.y,input.z)
	PARENT.visible = true
	#print("dropped")
	uppies = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
