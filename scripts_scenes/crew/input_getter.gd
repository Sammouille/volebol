extends RefCounted
class_name InputGetter

var input_changement:= 0
var input_deplacement:= Vector2.ZERO

var frame_jump:= 0

var charge_pass:= 0.0
var input_pass:= 0.0

var charge_shoot:= 0.0
var input_shoot:=0.0

func updateInput(delta: float):
	if input_pass != 0.0:
		input_pass = 0.0
	if input_shoot != 0.0:
		input_shoot = 0.0
	
	if Input.is_action_just_pressed("previous"):
		input_changement = -1
	elif Input.is_action_just_pressed("next"):
		input_changement = 1
	else:
		input_changement = 0
	
	input_deplacement = Vector2(
		Input.get_axis("left","shit"),
		Input.get_axis("up","down")
	)
	
	if Input.is_action_pressed("jump"):
		frame_jump += 1
	else:
		frame_jump = 0
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		charge_pass += delta
	else:
		if charge_pass != 0.0:
			input_pass = charge_pass
			charge_pass = 0.0
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		charge_shoot += delta
	else:
		if charge_shoot != 0.0:
			input_shoot = charge_shoot
			charge_shoot = 0.0
