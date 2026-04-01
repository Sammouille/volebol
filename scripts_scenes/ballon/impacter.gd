extends Node2D
class_name Impacter

var active

var current_precis_size:= 0.0
var current_large_size:= 0.0
var current_mod_contour:= 0.0

var color:= Color(0.5, 0.5, 0.5, 1.0)
var color_precis:= Color()

var centre_impact:= Vector2.ZERO

var duration:= 1.4
var duration_fullscreen:= 0.8
var latency:= 0.5
var max_opacity:= 1.0

var precis_size:= 44.4
var precis_grow_length:= 0.1

var large_size:= 1600.0
var large_grow_length:= 2.4
var large_mod_contour:= 0.1

signal fullscreened
signal fullscreen_began

func setup(_color: Color, _color_precis: Color, puissance_impact: float, position_impact: Vector2):
	active = true
	centre_impact = position_impact
	color = _color
	color.a = max_opacity
	color_precis = _color_precis
	show()
	evolution()

func evolution():
	get_tree().create_tween().tween_property(self, "current_precis_size", precis_size, precis_grow_length)
	get_tree().create_tween().tween_property(self, "current_large_size", large_size, duration)
	get_tree().create_tween().tween_property(self, "current_mod_contour", 1.8, duration)
	await get_tree().create_timer(duration).timeout
	fullscreen_began.emit()
	await get_tree().create_tween().tween_property(self, "current_mod_contour", 4.0, duration_fullscreen).finished
	fullscreened.emit()
	await get_tree().create_tween().tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), latency).finished
	finImpact()


func finImpact():
	active = false
	hide()
	current_precis_size= 0.0
	current_large_size= 0.0
	current_mod_contour= 0.0
	modulate = Color(1.0, 1.0, 1.0, 1.0)

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(centre_impact, current_precis_size, color_precis, true)
	draw_circle(centre_impact, current_large_size, color, false, current_large_size * current_mod_contour)
