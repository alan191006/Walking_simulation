extends Sprite

func _ready():
	visible = false
		
var is_paused = false setget set_is_paused
	
func _unhandled_input(event):
	if event.is_action_pressed("book"):
		self.is_paused = not is_paused 

	
func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	match Input.get_mouse_mode():
				Input.MOUSE_MODE_CAPTURED:
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				Input.MOUSE_MODE_VISIBLE:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
