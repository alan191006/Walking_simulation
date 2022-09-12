extends KinematicBody

export(NodePath) var cam_path := NodePath("Camera")
onready var cam: Camera = get_node(cam_path)

var gravity : float = 15.0
var stop_on_slope := true
export var jump_height := 10
onready var floor_max_angle: float = deg2rad(45.0)

var moveSpeed : float = 16.0
export var acceleration := 8
export var deceleration := 10
export(float, 0.0, 1.0, 0.05) var air_control := 0.3

var input_axis := Vector2()
var velocity := Vector3()
var direction := Vector3()

var is_inventory_on = false

# cam look
var minLookAngle : float = 0.0
var maxLookAngle : float = 180.0
var lookSensitivity : float = 10.0
var snap := Vector3()

# vectors
var mouseDelta : Vector2 = Vector2()

func _ready ():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta) -> void:
	if not is_inventory_on:
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
		
		velocity = move_and_slide_with_snap(velocity, snap, Vector3.UP, 
				stop_on_slope, 4, floor_max_angle)

func _process(delta):
	
	if not is_inventory_on:
		cam.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, minLookAngle, maxLookAngle)
		rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
		mouseDelta = Vector2()

func _input(event):
	
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
		
	if event.is_action_pressed("book"):
		is_inventory_on = not is_inventory_on
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("sprint"):
		moveSpeed = 30
	else:
		moveSpeed = 20

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
	var target: Vector3 = direction * moveSpeed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.linear_interpolate(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
