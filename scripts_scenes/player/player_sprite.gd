@tool
extends Node2D


@export var couleur: Color

const SIZE:= 44.0

func _draw() -> void:
	if get_parent().libero:
		draw_circle(Vector2.ZERO, SIZE, get_parent().crew.libero_color, false, 25.0)
	else:
		draw_circle(Vector2.ZERO, SIZE, get_parent().crew.color, false, 25.0)
	if !Engine.is_editor_hint():
		if get_parent().played:
			draw_circle(Vector2.ZERO, SIZE * 1.44, Color(1.0, 1.0, 1.0, 1.0), false, 7.0)
	
	draw_circle(Vector2.ZERO, SIZE, couleur, true)

func _process(delta: float) -> void:
	if get_parent().hauteur > 200:
		var mod_a = (get_parent().hauteur - 200.0) * 0.05
		self_modulate = Color(1.0, 1.0, 1.0, maxf(1.0 - mod_a, 0.0))
	else:
		self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	queue_redraw()
