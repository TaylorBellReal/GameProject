extends Sprite2D

var start_x
var start_y
var xdir = 1
var ydir = 1
var set
@export var boundary_x = 32
@export var boundary_y = 16
@export var speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.visible == true:
		if !set:
			set = true
			start_x = self.position.x
			start_y = self.position.y
		if self.position.x < (start_x + boundary_x) and self.position.x > (start_x - boundary_x):
			self.position.x + (speed * xdir)
		else:
			xdir = xdir *-1
			self.position.x + (speed * xdir)
			
		if self.position.y < (start_y + boundary_y) and self.position.y > (start_y - boundary_y):
			self.position.y + (speed * ydir)
		else:
			ydir = ydir *-1
			self.position.y + (speed * ydir)
		
	pass
