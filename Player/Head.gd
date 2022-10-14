extends KinematicBody


export(NodePath) var cam_path := NodePath("Camera")
onready var camera: Camera = get_node(cam_path)

onready var raycast = camera.get_node("RayCast")

var gravity : float = 25.0
var stop_on_slope := true
export var jump_height := 15
onready var floor_max_angle: float = deg2rad(45.0)
export var mouse_sensitivity := 2.0
export var y_limit := 90.0
var mouse_axis := Vector2()
export var acceleration := 8
export var deceleration := 10
var direction := Vector3()
var rot := Vector3()
export var speed := 200
var input_axis := Vector2()
var velocity := Vector3()
var up_direction := Vector3.UP
# stats
var curHp : int = 10
var maxHp : int = 10
var ammo : int = 15
var score: int = 0

# physics
var moveSpeed : float = 100
var jumpForce : float = 10.0
# var gravity : float = 800.0

# cam look
var minLookAngle : float = 0.0
var maxLookAngle : float = 180.0
var lookSensitivity : float = 10.0
var snap := Vector3()
export(float, 0.0, 1.0, 0.05) var air_control := 0.3
# vectors
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

var animal_interact =  {"NVN": false,
						"S"  : false}

func _ready ():
	# hide and lock the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# set the UI


# called 60 times a second
func _physics_process(delta):
	
	if raycast.is_colliding():
		if Input.is_action_just_pressed("interact"):
			info()

	# reset the x and z velocity
	vel.x = 0
	vel.z = 0
	
	var input = Vector2()
	
	# movement inputs
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
		
	input = input.normalized()
	
	# get the forward and right directions
	var forward = -global_transform.basis.y
	var right   = global_transform.basis.x
	
	var relativeDir = (forward * input.y + right * input.x)
	# set the velocity
	vel.x = relativeDir.x * moveSpeed
	vel.z = relativeDir.z * moveSpeed
	
	# apply gravity
	vel.y -= gravity * delta
	
	# move the player
	vel = move_and_slide(vel, Vector3.UP)
	
	# jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jump_height

# called every frame	
func _process(delta):
	
	# rotate the camera along the x axis
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	
	# clamp camera x rotation axis
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	# rotate the player along their y axis
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	
	# reset the mouse delta vector
	mouseDelta = Vector2()

# called when an input is detected
func _input(event):
	
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
	
	if event.is_action_pressed("sprint"):
		speed = 200
	else:
		speed = 100
		


func info():
	name = raycast.get_collider().name
	animal_interact[name] = true
	print(animal_interact)
