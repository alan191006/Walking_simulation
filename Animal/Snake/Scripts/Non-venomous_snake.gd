extends KinematicBody

enum {
	IDLE,
	FLEE,
	ATTACK
}

var state = IDLE

var moveSpeed  : float = 100.0
var visionDist : float = 30.0
var attackDist : float = 15.0

var gravity_multiplier : float = 3.0

onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)

onready var player : Node = get_node("/root/Main_scene/Player")

func _physics_process(delta):
	
	# calculate the direction to the player
	var dir = (player.translation - translation).normalized()
	var  distance = translation.distance_to(player.translation)
	
	match state:
		IDLE:
			var gra = Vector3.ZERO
			gra.y = 0 - gravity * delta
			move_and_slide(gra, Vector3.UP)
			if distance <= visionDist:
				state = FLEE
		FLEE:
			if distance <= attackDist:
				state = ATTACK
			if translation.distance_to(player.translation) > visionDist:
				state = IDLE
			dir.y = gravity * delta
			move_and_slide(-dir * moveSpeed, Vector3.UP)
		ATTACK:
			if translation.distance_to(player.translation) > attackDist:
				state = FLEE
			dir.y = 0 - gravity * delta
			move_and_slide(dir * moveSpeed, Vector3.UP)
				
	

