@tool
extends Node2D

const SIZE:= 17

var _up_color:= Color(0.0, 0.0, 0.0, 1.0)

var color:= Color(1.0, 1.0, 1.0, 1.0)

func _draw() -> void:
	
	if !Engine.is_editor_hint():
		if get_parent().touched_ground:
			draw_circle(Vector2.ZERO, SIZE, get_parent().last_crew.downed_color, false, 10.0)
		else:
			draw_circle(Vector2.ZERO, SIZE, get_parent().last_crew.color, false, 10.0)
			if get_parent().aimed:
				draw_circle(Vector2.ZERO, SIZE * 1.5, get_parent().aiming_crew.libero_color, false, 1.0 + abs(1.0-get_parent().aimed_ratio) * 20.0)
	else:
		draw_circle(Vector2.ZERO, SIZE, _up_color, false, 10.0)
	
	draw_circle(Vector2.ZERO, SIZE, color, true)

func _process(delta: float) -> void:
	if get_parent().hauteur > 250:
		var mod_a = (get_parent().hauteur - 250) * 0.0005
		self_modulate = Color(1.0, 1.0, 1.0, maxf(1.0 - mod_a, 0.0))
	else:
		self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	queue_redraw()
