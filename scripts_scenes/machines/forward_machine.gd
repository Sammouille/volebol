@tool
extends Node2D

@onready var gym:= get_tree().get_first_node_in_group("GymHandler")

@export var turn_speed:= 1.0

var current_aim:= Vector2.LEFT * 30.0
var last_aim:= Vector2.LEFT * 30.0

var charge:= 0.0


func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_colored_polygon([%Looker.position + Vector2(44.0,00.0), %Looker.position.rotated(0.2), %Looker.position, %Looker.position.rotated(-0.2)], get_parent().crew.color)
	if charge != 0.0:
		draw_line(-%Looker.position * 100.0, %Looker.position * 100.0, get_parent().crew.color,charge * 50.0)
