extends Node

var time_passed:= 0.0

var delta_mod:= 1.0

func getTimePassedString():
	var minutes = int(time_passed / 60)
	var seconds = int(time_passed) % 60
	var milliseconds = int((time_passed - int(time_passed)) * 100)
	return "%02d:%02d.%02d " % [minutes,seconds,milliseconds]

func _physics_process(delta: float) -> void:
	time_passed += delta * delta_mod
	
	#print(getTimePassedString())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			delta_mod += 0.1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			delta_mod = maxf(delta_mod - 0.1, 0.0)
