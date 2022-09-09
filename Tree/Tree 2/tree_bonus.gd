extends CanvasLayer
onready var colour = $"4LaneModeClrCtrl"
onready var anim = $AnimationPlayer

export(String, "white", "red", "blue", "green", "yellow", "purple", "joke") var ColourMode

func _ready():
	colour = Color(255,0,0)
	set_colours()
	dev_mode_colour_cheat()
	
	

func set_colours():
	if ColourMode == "white":
	 $"4LaneModeClrCtrl".modulate = Color(0,0,0)
	elif ColourMode == "red":
		 colour = Color(255,0,0)
	elif ColourMode == "blue":
		 colour = Color(0,0,255)
	elif ColourMode == "green":
		 colour = Color(0,255,0)
	elif ColourMode == "yellow":
		 colour = Color(255,255,0)
	elif ColourMode == "purple":
		 colour = Color(255,0,255)
	elif ColourMode == "joke":
		colour = Color(150,75,0)

func dev_mode_colour_cheat():
	if Input.is_action_just_pressed("cheat_code_white"):
		ColourMode = "white"
	if Input.is_action_just_pressed("cheat_code_red"):
		ColourMode = "red"
	if Input.is_action_just_pressed("cheat_code_blue"):
		ColourMode = "blue"
	if Input.is_action_just_pressed("cheat_code_green"):
		ColourMode = "green"
	if Input.is_action_just_pressed("cheat_code_yellow"):
		ColourMode = "yellow"
	if Input.is_action_just_pressed("cheat_code_purple"):
		ColourMode = "purple"
	if Input.is_action_just_pressed("cheat_code_joke"):
		ColourMode = "joke"
