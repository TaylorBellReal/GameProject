extends CharacterBody3D

#@export var SCREEN_NOTIF : VisibleOnScreenNotifier3D
@export var PLAYER : Node
@export var PEN : Node

var pet_picked:int = StartVars.pet_picked

var Sounds = [preload("res://Sounds/Untitled video.mp3"),
	preload("res://Sounds/wooden-door-slamming-close-79934.mp3")]

var s = null

var Pets = [preload("res://Sprites/PetRelated/Pet/furbeazel_Sprite.png"),
	preload("res://Sprites/PetRelated/Pet/bones_Sprite.png"),preload("res://Sprites/PetRelated/Pet/aileen2_Sprite.png")]

var Indicators = [preload("res://Sprites/PetRelated/UI/hungy.png"),
	preload("res://Sprites/PetRelated/UI/eepy.png"),preload("res://Sprites/PetRelated/UI/angy.png"),
	preload("res://Sprites/PetRelated/UI/bubbletext.png"),preload("res://Sprites/PetRelated/UI/dirty.png"),
	preload("res://Sprites/PetRelated/UI/siccy.png")]

var Pens = [preload("res://Sprites/pet_HouseB2_Sprite.png"),
	preload("res://Sprites/pet_HouseB_Sprite.png")]

################################################
#Vars for picking up the pet
var object_name:String = StartVars.names[pet_picked]
var held_sprite:Texture = Pets[pet_picked]
var default_scale = Vector2(2,2)
var default_position = Vector2(900,800)
var uppies = false
################################################

@onready var MESH : Node = self.find_child("Mesh")

@onready var ICON : Node = self.find_child("Icon")
@onready var ICON_starty = ICON.position.y
var ICON_dir = 1
var ICON_wiggle_bounds = .01
var ICON_wiggle_speed = .001

const SPEED = .5
const JUMP_VELOCITY = 4.5

var player_in_range
var player_in_sight : bool
var looked_away : bool
var personal_space = .75

var sleepy:bool = false
var sleep_cure:bool = false
var state_switch:bool = false



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	MESH.set_albedo_texture(Pets[pet_picked],0)
	ICON.visible = false


func check_if_facing(target, threshold):
	if rotation in range(global_position.angle_to(target) - threshold, global_position.angle_to(target) + threshold):
		return true

func _physics_process(delta):
	sight_update()
	state()
	if ICON.position.y >= ICON_starty + ICON_wiggle_bounds:
		ICON_dir = -1
	elif ICON.position.y <= ICON_starty - ICON_wiggle_bounds:
		ICON_dir = 1
		
	ICON.position.y += ICON_wiggle_speed * ICON_dir
		
			
func sight_update():
	if player_in_sight:
		#print("Looking")
		looked_away = false
		pass
	else:
		if !looked_away:
			looked_away = true
			movement()
			print("Not Looking")
		pass
		
func movement():
	#Furbeasel ===================================================================
	if pet_picked == 0:
		if !sleepy and !uppies:
			s = Sounds[0]
			
			var x = (($"../Player".position.x - position.x) * 2/3)
			var z = (($"../Player".position.z - position.z) * 2/3)
			if abs(x) < personal_space:
				x = personal_space * (x/abs(x))
			if abs(z) < personal_space:
				z = personal_space * (z/abs(z))
			position.x = x + position.x
			position.z = z + position.z
			
			if s != null:
				$"../SFX".stream = s
				$"../SFX".play()
				s = null
	#Bones ========================================================================
	elif pet_picked == 1:
		pass
	#Alien ===========================================================================
	elif pet_picked == 2:
		if !uppies:
			position.x = (($"../Player".position.x - position.x) * 2/3) + position.x
			position.z = (($"../Player".position.z - position.z) * 2/3) + position.z
	
func state():
	#Disturby ======================================================================
	if pet_picked == 0:
		if sleepy:
			if !state_switch:
				#print("I ran!")
				ICON.set_albedo_texture(Indicators[1],1)
				ICON.visible = true
				state_switch = true
				s = Sounds[1]
			if looked_away:
				self.visible = false
				PEN.set_albedo_texture(Pens[1],0)
				position.x = PEN.position.x
				position.z = PEN.position.z
				
				if s != null:
					$"../SFX".stream = s
					$"../SFX".play()
					s = null
		elif !sleepy:
			if looked_away and sleep_cure:
				state_switch = false
				self.visible = true
				PEN.set_albedo_texture(Pens[0],0)
				ICON.visible = false
				sleep_cure = false
	#Bones ========================================================================================
	elif pet_picked == 1:
		
		var undo = '''
		if sleepy:
			if !state_switch:
				#print("I ran!")
				ICON.set_albedo_texture(Indicators[1],1)
				ICON.visible = true
				state_switch = true
				s = Sounds[1]
			if looked_away:
				self.visible = false
				PEN.set_albedo_texture(Pens[1],0)
				position.x = PEN.position.x
				position.z = PEN.position.z
				
				if s != null:
					$"../SFX".stream = s
					$"../SFX".play()
					s = null
		elif !sleepy:
			if looked_away and sleep_cure:
				state_switch = false
				self.visible = true
				PEN.set_albedo_texture(Pens[0],0)
				ICON.visible = false
				sleep_cure = false'''
		pass #gonna make bones actually do nothing
	# Alein ===============================================================================================================
	elif pet_picked == 2:
		if sleepy:
			if !state_switch:
				#print("I ran!")
				ICON.set_albedo_texture(Indicators[1],1)
				ICON.visible = true
				state_switch = true
				s = Sounds[1]
		elif !sleepy:
			if looked_away and sleep_cure:
				state_switch = false
				self.visible = true
				PEN.set_albedo_texture(Pens[0],0)
				ICON.visible = false
				sleep_cure = false

func _input(event):
	if event.is_action_pressed("extra"):
		print(sleepy)


####################################################
#Functions for picking up the pet
###############################################
func get_grabbed() -> void:
	self.visible = false
	uppies = true

func drop(input) -> void:
	uppies = false
	self.position = Vector3(input.x,get_parent().position.y+.5,input.z)
	self.visible = true
	#print("dropped")

####################################################
#Functions for timers and pet states
###############################################

func _on_action_timer_timeout():
	pass # Replace with function body.
