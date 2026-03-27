extends Node2D
class_name Impact


var ultimate_color:= Color(0.0, 0.0, 0.0, 0.0)

var current_size:= 0.0
var current_color:= Color()

var max_size:= 150.0
var grow_length:= 0.2
var duration:= 0.8
var latency:= 0.5
var max_opacity:= 0.8

func setup(_color: Color):
	current_color = _color
	current_color.a = max_opacity
	ultimate_color = _color
	ultimate_color.a = 0.0
	evolution()

func evolution():
	await get_tree().create_tween().tween_property(self, "current_size", 150.0, grow_length)
	await get_tree().create_timer(duration).timeout
	await get_tree().create_tween().tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), latency).finished
	
	queue_free()

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, current_size, current_color, true)
