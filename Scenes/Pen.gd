extends StaticBody3D

var player_in_sight:bool = false
var uppies:bool = false
@export var object_name:String = "Pet Pen"
@export var held_sprite:Texture = preload("res://Sprites/PetRelated/UI/Sprites/pet_HouseB2_Sprite.png")
@export var default_scale = Vector2(1,1)
@export var default_position = Vector2(900,514)
# Called when the node enters the scene tree for the first time.

func get_grabbed() -> void:
	get_parent().visible = false
	uppies = true

func drop(input) -> void:
	get_parent().position = Vector3(input.x,get_parent().position.y,input.z)
	get_parent().visible = true
	#print("dropped")
	uppies = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
