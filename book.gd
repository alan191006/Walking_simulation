extends Sprite

func _ready():
	visible = false
		

func _process(delta):
	if Input.is_action_just_pressed("book"):
		visible = not visible 
