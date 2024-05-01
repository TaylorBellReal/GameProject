extends CharacterBody3D

#@export var SCREEN_NOTIF : VisibleOnScreenNotifier3D
@export var PLAYER : Node
@export var PEN : Node
@export var BOWL : Node
@export var FRIS : Node

var pet_picked:int = StartVars.pet_picked

var Sounds = [preload("res://Sounds/Untitled video.mp3"),
	preload("res://Sounds/wooden-door-slamming-close-79934.mp3")]

var s = null

var Pets = [preload("res://Sprites/PetRelated/Pet/furbeazel_Sprite.png"),
	preload("res://Sprites/PetRelated/Pet/bones_Sprite.png"),preload("res://Sprites/PetRelated/Pet/aileen2_Sprite.png")]

#hungy, eepy, angy, bubble. dirty, siccy
var Indicators = [preload("res://Sprites/PetRelated/UI/hungy.png"),
	preload("res://Sprites/PetRelated/UI/eepy.png"),preload("res://Sprites/PetRelated/UI/angy.png"),
	preload("res://Sprites/PetRelated/UI/bubbletext.png"),preload("res://Sprites/PetRelated/UI/dirty.png"),
	preload("res://Sprites/PetRelated/UI/siccy.png")]

var Pens = [preload("res://Sprites/pet_HouseB2_Sprite.png"),
	preload("res://Sprites/pet_HouseB_Sprite.png")]

var Bowls = [preload("res://Sprites/PetRelated/UI/Sprites/bowl1_Sprite.png"),
	preload("res://Sprites/PetRelated/UI/Sprites/bowl2_Sprite.png")]

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

var mood = "none"
var sleep_cure:bool = false
var hungy_cure:bool = false
var angy_cure:bool = false
var bubble_cure:bool = false
var siccy_cure:bool = false
var dirty_cure:bool = false
var thrown_fris = false
var state_switch:bool = false

var move_switch:bool = false

var random = RandomNumberGenerator.new()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	random.randomize()
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
			print("Not Looking")
		pass
	movement()
		
func movement():
	#Furbeasel ===================================================================
	if pet_picked == 0:
		s = Sounds[0]
		print(mood)
		if mood == "hungy" and !uppies:
			self.position.x = BOWL.position.x + .1
			self.position.z = BOWL.position.z
			
			if s != null:
				$"../SFX".stream = s
				$"../SFX".play()
				s = null
				
		elif mood == "angy" and !uppies:
			if FRIS.uppies == false:
				self.position.x = FRIS.position.x + .1
				self.position.z = FRIS.position.z
				
				if thrown_fris == true:
					angy_cure = true
					thrown_fris = false
				
				if s != null:
					$"../SFX".stream = s
					$"../SFX".play()
					s = null
				pass
			
		elif mood != "asleep" and !uppies and looked_away:
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
		if !looked_away:
			move_switch = true
		if !uppies and looked_away and move_switch:
			position.x = (($"../Player".position.x - position.x) * 2/3) + position.x
			position.z = (($"../Player".position.z - position.z) * 2/3) + position.z
			move_switch = false

####################################################################
#State handles setting icons and interpreting moods
####################################################################
#mood num = hungy, sleepy, angy, bubble. dirty, siccy
func state():
	#Disturby ======================================================================
	# hungy(foodbowl), sleepy(Pethouse), angy(frisbee)
	if pet_picked == 0:
		if mood == "sleepy":
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
				mood = "asleep"
				s = Sounds[1]
				if s != null:
					$"../SFX".stream = s
					$"../SFX".play()
					s = null
					
		elif mood == "hungy":
			if !state_switch:
				ICON.set_albedo_texture(Indicators[0],1)
				ICON.visible = true
				state_switch = true
				
			if hungy_cure:
				print("ran")
				BOWL.set_albedo_texture(Bowls[0],0)
				state_switch = false
				ICON.visible = false
				hungy_cure = false
				mood = "none"
				
		elif mood == "angy":
			if !state_switch:
				ICON.set_albedo_texture(Indicators[2],1)
				ICON.visible = true
				state_switch = true
			
			if angy_cure:
				state_switch = false
				ICON.visible = false
				hungy_cure = false
				mood = "none"
				
		elif mood != "sleepy":
			if looked_away and sleep_cure:
				state_switch = false
				self.visible = true
				PEN.set_albedo_texture(Pens[0],0)
				ICON.visible = false
				sleep_cure = false
	#Bones ========================================================================================
	#bubble, siccy(medicince)
	elif pet_picked == 1:
		if mood == "bubble":
			if !state_switch:
				#print("I ran!")
				ICON.set_albedo_texture(Indicators[3],1)
				ICON.visible = true
				state_switch = true
			if bubble_cure:
				state_switch = false
				ICON.visible = false
				bubble_cure = false
				mood = "none"
				
		elif mood == "siccy":
			if !state_switch:
				#print("I ran!")
				ICON.set_albedo_texture(Indicators[5],1)
				ICON.visible = true
				state_switch = true
			if siccy_cure:
				state_switch = false
				ICON.visible = false
				siccy_cure = false
				mood = "none"
		else:
			
			pass #gonna make bones actually do nothing
	# Alein ===============================================================================================================
	#siccy(medicine), sleepy(pethouse), dirty(waterhose)
	elif pet_picked == 2:
		if mood == "sleepy":
			if !state_switch:
				#print("I ran!")
				ICON.set_albedo_texture(Indicators[1],1)
				ICON.visible = true
				state_switch = true
				s = Sounds[1]
		
		elif mood == "siccy":
			if !state_switch:
				#print("I ran!")
				ICON.set_albedo_texture(Indicators[5],1)
				ICON.visible = true
				state_switch = true
			if siccy_cure:
				state_switch = false
				ICON.visible = false
				siccy_cure = false
				mood = "none"
		
		elif mood == "dirty":
			if !state_switch:
				#print("I ran!")
				ICON.set_albedo_texture(Indicators[4],1)
				ICON.visible = true
				state_switch = true
			if dirty_cure:
				state_switch = false
				ICON.visible = false
				dirty_cure = false
				mood = "none"
				
		elif mood != "sleepy":
			if sleep_cure:
				state_switch = false
				self.visible = true
				PEN.set_albedo_texture(Pens[0],0)
				ICON.visible = false
				sleep_cure = false

func _input(event):
	if event.is_action_pressed("extra"):
		pass


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
	
	#putting Aileen in pen to sleep
	if pet_picked == 2 and PLAYER.PEN.player_in_sight == true and mood == "sleepy":
		self.visible = false
		PEN.set_albedo_texture(Pens[1],0)
		position.x = PEN.position.x
		position.z = PEN.position.z
		
		s = Sounds[1]
		if s != null:
			$"../SFX".stream = s
			$"../SFX".play()
			s = null
	#print("dropped")

####################################################
#Functions for timers and pet states
###############################################
func _on_action_timer_timeout():
	print("timer")
	#var new_mood = 4
	var new_mood = random.randi_range(0, 5)
	
	#bones always fixes himself
	if pet_picked == 1:
		ICON.visible = false
		mood = "none"
	
	#For moods and others
	if ICON.visible == true:
		if mood == "asleep":
			mood = "none"
			sleep_cure = true
		#gameover logic
		else:
			pass
			
			
	#Else here decides pet states
	#mood num = hungy, sleepy, angy, bubble. dirty, siccy
	else:
		#state_switch = false
		#Disturby ======================================================================
		if pet_picked == 0:
			if new_mood == 0:
				mood = "hungy"
			elif new_mood == 1:
				mood = "sleepy"
			elif new_mood == 2:
				mood = "angy"
			
		#Bones ========================================================================================
		elif pet_picked == 1:
			if new_mood == 3:
				mood = "bubble"
			elif new_mood == 5:
				mood = "siccy"
			pass #gonna make bones actually do nothing
		# Alein ===============================================================================================================
		elif pet_picked == 2:
			if new_mood == 5:
				mood = "siccy"
			elif new_mood == 1:
				mood = "sleepy"
			elif new_mood == 4:
				mood = "dirty"
	pass # Replace with function body.
