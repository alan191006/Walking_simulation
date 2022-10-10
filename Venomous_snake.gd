extends KinematicBody

enum {
	IDLE,
	ATTACK
}

var state = IDLE

var moveSpeed  : float = 100.0
var visionDist : float = 100.0
# Snakes/Venomous/Venomous_snake
var gravity_multiplier : float = 3.0

onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)

onready var player : Node = get_node("/root/Main_scene/Player")

func _physics_process(delta):
	
	# calculate the direction to the player
	var dir = (player.translation - translation).normalized()
	dir.y = 0 - gravity * delta
	
	match state:
		IDLE:
			var gra = Vector3.ZERO
			gra.y = 0 - gravity * delta
			move_and_slide(gra, Vector3.UP)
			if translation.distance_to(player.translation) <= visionDist:
				state = ATTACK
		ATTACK:
			if translation.distance_to(player.translation) > visionDist:
				state = IDLE
			else:
				move_and_slide(dir * moveSpeed, Vector3.UP)
				
	

