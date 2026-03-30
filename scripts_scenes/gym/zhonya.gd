extends Node

var time_passed:= 0.0

var delta_mod:= 1.0

var denominateur_frames_horizontal:= 3
var flash_min_frame:= 10
var mod_piquet:= 2.5

var index_stop:= 0

var stopped:= false

func getTimePassedString():
	var minutes = int(time_passed / 60)
	var seconds = int(time_passed) % 60
	var milliseconds = int((time_passed - int(time_passed)) * 100)
	return "%02d:%02d.%02d " % [minutes,seconds,milliseconds]

func smashStop(puissance_horizontale: float, puissance_verticale: float):
	stopped = true
	var frames_arret : int = puissance_horizontale / denominateur_frames_horizontal
	if frames_arret >= flash_min_frame:
		index_stop = frames_arret
		if puissance_verticale < 0.0:
			%Camera2D.pression = true
			index_stop *= mod_piquet
		print(index_stop)

func _physics_process(delta: float) -> void:
	if index_stop > 0:
		delta_mod = 0.0
		index_stop -= 1
	elif stopped:
		delta_mod = 1.0
		stopped = false
		%Camera2D.pression = false
	time_passed += delta * delta_mod
	
	#print(getTimePassedString())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			delta_mod += 0.1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			delta_mod = maxf(delta_mod - 0.1, 0.0)
