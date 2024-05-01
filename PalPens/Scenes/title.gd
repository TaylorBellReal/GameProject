extends Control


@onready var animplay = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Panel.visible = true
	$Panel2.visible = false
	$Startpagebg.visible = true
	play_music()
	animplay.play("start_anim")
	await animplay.animation_finished
	$Startpagebg/Splashscreen2.on_off_switch = true

func play_music():
	if $Music.playing == false:
		$Music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	play_music()
	pass

func game_start():
	pass

func _on_pet_1_pressed():
	StartVars.pet_picked = 0
	game_start()
	animplay.play("fur_start")
	await animplay.animation_finished
	get_tree().change_scene_to_file("res://Scenes/World.tscn")


func _on_pet_2_pressed():
	StartVars.pet_picked = 1
	animplay.play("bone_start")
	await animplay.animation_finished
	get_tree().change_scene_to_file("res://Scenes/World.tscn")


func _on_pet_3_pressed():
	StartVars.pet_picked = 2
	animplay.play("Aile_start")
	await animplay.animation_finished
	get_tree().change_scene_to_file("res://Scenes/World.tscn")


func _on_button_pressed():
	$Panel2.visible = true
	animplay.play("from_title")
	await animplay.animation_finished
	$Startpagebg.visible = false
	$Panel2.visible = false
	pass # Replace with function body.


func _on_return_pressed():
	$Panel/Credits.visible = false
	$Startpagebg.visible = true


func _on_credits_button_pressed():
	$Panel2.visible = true
	$Panel/Credits.visible = true
	animplay.play('from_title')
	await animplay.animation_finished
	$Startpagebg.visible = false
	$Panel2.visible = false
	pass # Replace with function body.
