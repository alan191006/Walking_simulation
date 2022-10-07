extends Sprite


func _ready():
	visible = true
	
func _on_Button_pressed():
	visible = not visible
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
