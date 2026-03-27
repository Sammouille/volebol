@tool
extends Node2D


func _draw() -> void:
	
	if !Engine.is_editor_hint():
		if get_parent().touched_ground:
			draw_circle(Vector2.ZERO, get_parent().SIZE, get_parent().last_crew.downed_color, false, 5.0)
		else:
			draw_circle(Vector2.ZERO, get_parent().SIZE, get_parent().last_crew.color, false, 5.0)
	else:
		draw_circle(Vector2.ZERO, get_parent().SIZE, get_parent().last_crew.color, false, 5.0)
	
	draw_circle(Vector2.ZERO, get_parent().SIZE, get_parent().couleur, true)

func _process(delta: float) -> void:
	if get_parent().hauteur > 2.0:
		var mod_a = (get_parent().hauteur - 2.0) * 0.05
		self_modulate = Color(1.0, 1.0, 1.0, maxf(1.0 - mod_a, 0.0))
	else:
		self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	queue_redraw()
