@tool
extends Node2D

@export var couleur_sol: Color
@export var couleur_bande: Color

var size:= Vector2(1800.0, 900.0)
var origine:= Vector2(-900.0, -450.0)

func _process(delta: float) -> void:
	queue_redraw()

func _ready() -> void:
	if !Engine.is_editor_hint():
		var scale_ratio = (DisplayServer.window_get_size().x / 1.5)/size.x
		scale = Vector2(scale_ratio, scale_ratio)
		

func _draw() -> void:
	draw_rect(Rect2(origine, size), couleur_sol, true)
	draw_rect(Rect2(origine, size), couleur_bande, false, 15.0)
	draw_rect(Rect2(origine, Vector2(600.0,0.0)), couleur_bande, false, 15.0)
	draw_rect(Rect2(origine + Vector2(600.0,0.0), Vector2(600.0, 900.0)), couleur_bande, false, 15.0)
	draw_rect(Rect2(origine + Vector2(600.0,0.0), Vector2(600.0, 900.0)), couleur_bande, false, 15.0)
	draw_line(origine + Vector2(size.x * 0.5, 0.0), origine + Vector2(size.x * 0.5, 900.0), couleur_bande, 15.0)
