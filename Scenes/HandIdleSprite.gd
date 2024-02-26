extends Sprite2D

@export var PLAYER : Node

var sightArray = []

var _mouse_input : bool = false
var _click_fixer : bool = false
var _mouse_clicked : bool = false
var MOUSE_SENSITIVITY = 1
var temp :bool = false
var tempx
var tempy
#var test = PLAYER.position

var runner:int = 0 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED_HIDDEN
	_click_fixer = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	#_mouse_clicked = event.is_action_pressed("click") and Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED_HIDDEN
	
	if event.is_action_pressed("click") and Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED_HIDDEN:
		if !sightArray == []:
			print(sightArray[runner])
			runner += 1
			if runner >= sightArray.size():
				runner = 0 #comment
				var hello
	
	if _mouse_input:
		if !temp:
			temp = true
			tempx = position.x
			tempy = position.y
			#var tempfix = Vector2(800,400)
			#Input.warp_mouse(tempfix)
			position = get_viewport().get_mouse_position()
			
			sightArray = sight_update()
			print(sightArray)
			runner = 0
			#print(tempx + tempy)
		#position.x += event.relative.x #* MOUSE_SENSITIVITY
		#position.y += event.relative.y #* MOUSE_SENSITIVITY
		#position.x += get_viewport().get_mouse_position().x
		#position.y += get_viewport().get_mouse_position().y
		position = get_viewport().get_mouse_position()
		update_scale()
	elif _click_fixer:
		if temp:
			scale = Vector2(1,1)
			position.x = tempx
			position.y = tempy
			temp = false
		else:
			pass

# Function to update the sprite's scale based on its Y value
func update_scale():
	# Get the current Y position of the sprite
	var y_position = 650 - position.y
	
	# Calculate the scaling factor based on the Y value
	var scaling_factor = 1.0 - abs(y_position) * 0.001  # Adjust the multiplier as needed
	
	# Set the new scale of the sprite
	scale = Vector2(scaling_factor, scaling_factor)

func sight_update():
	var temp = []
	if PLAYER.PET.player_in_sight:
		temp.append(PLAYER.PET)
	if PLAYER.PEN.player_in_sight:
		temp.append(PLAYER.PEN)
		
	return temp
