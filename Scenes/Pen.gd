extends StaticBody3D

var player_in_sight:bool = false
var uppies:bool = false
var object_name:String = "Pet Pen"
# Called when the node enters the scene tree for the first time.

func get_grabbed() -> void:
	get_parent().visible = false
	uppies = true

func drop(input) -> void:
	get_parent().position = Vector3(input.x,get_parent().position.y,input.z)
	get_parent().visible = true
	print("dropped")
	uppies = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
