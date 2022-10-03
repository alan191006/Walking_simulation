extends KinematicBody


export(NodePath) var cam_path := NodePath("Camera")
onready var cam: Camera = get_node(cam_path)
export var jump_height := 500
export var gravity_multiplier := 4
var stop_on_slope := true
onready var floor_max_angle: float = deg2rad(45.0)
export var mouse_sensitivity := 2.0
export var y_limit := 90.0
var mouse_axis := Vector2()
export var acceleration := 8
export var deceleration := 10
var direction := Vector3()
var rot := Vector3()
export var speed := 2000
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
var gravity : float = 1000.0

# cam look
var minLookAngle : float = 0.0
var maxLookAngle : float = 180.0
var lookSensitivity : float = 10.0
var snap := Vector3()
export(float, 0.0, 1.0, 0.05) var air_control := 0.3
# vectors
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

# components
onready var camera : Camera = get_node("Camera")

func _ready ():
	
	# hide and lock the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# set the UI


# called 60 times a second
func _physics_process(delta) -> void:
	input_axis = Input.get_vector("move_back", "move_forward",
			"move_left", "move_right")
	
	direction_input()
	
	if is_on_floor():
		snap = -get_floor_normal() - get_floor_velocity() * delta
		
		# Workaround for sliding down after jump on slope
		if velocity.y < 0:
			velocity.y = 0
		
		if Input.is_action_just_pressed("jump"):
			snap = Vector3.ZERO
			velocity.y = jump_height
	else:
		# Workaround for 'vertical bump' when going off platform
		if snap != Vector3.ZERO && velocity.y != 0:
			velocity.y = 0
		
		snap = Vector3.ZERO
		
		velocity.y -= gravity * delta
	
	accelerate(delta)
	
	velocity = move_and_slide_with_snap(velocity, snap, up_direction, 
			stop_on_slope, 4, floor_max_angle)


# called every frame	
func _process(delta):
	
	# rotate the camera along the x axis
	cam.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	
	# clamp camera x rotation axis
	cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	# rotate the player along their y axis
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	
	# reset the mouse delta vector
	mouseDelta = Vector2()

# called when an input is detected
func _input(event):
	
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
	
	if event.is_action_pressed("sprint"):
		speed = 4000
	else:
		speed = 500
		


func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if input_axis.x >= 0.5:
		direction += aim.z
	if input_axis.x <= -0.5:
		direction -= aim.z
	if input_axis.y <= -0.5:
		direction -= aim.x
	if input_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()


func accelerate(delta: float) -> void:
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.linear_interpolate(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
