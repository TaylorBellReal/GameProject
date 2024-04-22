extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pet_1_pressed():
	StartVars.pet_picked = 0
	get_tree().change_scene_to_file("res://Scenes/World.tscn")


func _on_pet_2_pressed():
	StartVars.pet_picked = 1
	get_tree().change_scene_to_file("res://Scenes/World.tscn")


func _on_pet_3_pressed():
	StartVars.pet_picked = 2
	get_tree().change_scene_to_file("res://Scenes/World.tscn")
