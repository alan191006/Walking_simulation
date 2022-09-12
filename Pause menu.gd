extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_paused = false setget set_is_paused

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = not visible 


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
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

func _on_Resume_pressed():
	self.is_paused = false 

func _on_Quit_pressed():
	get_tree().quit()
