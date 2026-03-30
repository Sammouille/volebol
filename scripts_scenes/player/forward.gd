@tool
extends Node2D

@onready var gym:= get_tree().get_first_node_in_group("GymHandler")

@export var turn_speed:= 1.0

var current_aim:= Vector2.RIGHT * 30.0
var last_aim:= Vector2.RIGHT * 30.0

var charge:= 0.0

func _ready() -> void:
	if !Engine.is_editor_hint():
		Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CONFINED

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_colored_polygon([%Looker.position + Vector2(44.0,00.0), %Looker.position.rotated(0.2), %Looker.position, %Looker.position.rotated(-0.2)], get_parent().crew.color)
	if charge != 0.0:
		draw_line(-%Looker.position * 100.0, %Looker.position * 100.0, get_parent().crew.color,charge * 50.0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#print(event.global_position)
		#last_aim = (global_position + event.position).normalized() * 30.0
		last_aim = (event.global_position - global_position).normalized() * 30.0

func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		if get_parent().played:
			if current_aim != last_aim:
				current_aim = current_aim.slerp(last_aim, turn_speed * delta)
			
			look_at(global_position + current_aim)
		elif gym.ballon_actif:
			look_at(gym.ballon_actif.global_position)
			#look_at(last_aim)
			#print(global_position)
			#print(last_aim)
		
