extends Node2D

var angle_tir:= Vector2(1.0,0.0)
var activated_hit: PackedVector2Array
var color:= Color()

var index:= 0

var hit_simple: PackedVector2Array = [
		angle_tir*2600 + Vector2(0,-30), 
		angle_tir*2600 + Vector2(0,30), 
		
		angle_tir.rotated(0.14)* 150,
		angle_tir.rotated(0.33)* 300, 
		
		Vector2.ZERO, 
		
		angle_tir.rotated(-0.33) * 300, 
		angle_tir.rotated(-0.14) * 150]

var hit_bien: PackedVector2Array = [
		angle_tir*2600 + Vector2(0,-30), 
		angle_tir*2600 + Vector2(0,30), 
		
		angle_tir.rotated(0.14)* 150,
		angle_tir.rotated(0.28)* 300, 
		
		angle_tir.rotated(0.4)* 150,
		angle_tir.rotated(0.79)* 300, 
		
		Vector2.ZERO, 
		
		angle_tir.rotated(-0.79)* 300, 
		angle_tir.rotated(-0.4)* 150,
		
		angle_tir.rotated(-0.28) * 300, 
		angle_tir.rotated(-0.14) * 150]

var hit_excellent: PackedVector2Array = [
		angle_tir*2600 + Vector2(0,-30), 
		angle_tir*2600 + Vector2(0,30), 
		
		angle_tir.rotated(0.14)* 150,
		angle_tir.rotated(0.28)* 300, 
		
		angle_tir.rotated(0.44)* 150,
		angle_tir.rotated(0.79)* 300, 
		
		angle_tir.rotated(0.86)* 150,
		angle_tir.rotated(1.31)* 300, 
		
		Vector2.ZERO, 
		
		angle_tir.rotated(-1.31)* 300,
		angle_tir.rotated(-0.86)* 150, 
		
		angle_tir.rotated(-0.79)* 300, 
		angle_tir.rotated(-0.44)* 150,
		
		angle_tir.rotated(-0.28) * 300, 
		angle_tir.rotated(-0.14) * 150]

var hit_smashed: PackedVector2Array = [
		angle_tir*2600 + Vector2(0,-30), 
		angle_tir*2600 + Vector2(0,30), 
		
		angle_tir.rotated(0.14)* 150,
		angle_tir.rotated(0.28)* 300, 
		
		angle_tir.rotated(0.44)* 150,
		angle_tir.rotated(0.79)* 300, 
		
		angle_tir.rotated(0.95)* 150,
		angle_tir.rotated(1.42)* 300, 
		
		angle_tir.rotated(PI*0.5)* 150,
		angle_tir.rotated(1.9)* 300, 
		
		Vector2.ZERO, 
		
		angle_tir.rotated(-1.9)* 300,
		angle_tir.rotated(-PI*0.5)* 150, 
		
		angle_tir.rotated(-1.42)* 300,
		angle_tir.rotated(-0.95)* 150, 
		
		angle_tir.rotated(-0.79)* 300, 
		angle_tir.rotated(-0.44)* 150,
		
		angle_tir.rotated(-0.28) * 300, 
		angle_tir.rotated(-0.14) * 150]

@onready var hits:= [hit_simple, hit_bien, hit_excellent, hit_smashed]

func fx_hit(_position: Vector2, hit_type: int, _color: Color, angle: Vector2, duration: int):
	position = _position
	activated_hit = hits[hit_type]
	color = _color
	angle_tir = angle
	index = duration
	queue_redraw()
	

func _process(delta: float) -> void:
	if index >= 0:
		index -= 1
	elif !activated_hit.is_empty():
		queue_redraw()
		activated_hit.clear() 
	
	

func _draw() -> void:
	if !activated_hit.is_empty():
		draw_colored_polygon(activated_hit, Color(1.0, 0.0, 0.0, 1.0))
