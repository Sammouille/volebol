extends Node2D

var activated_hit: PackedVector2Array
var color:= Color()

var index:= 0

var hit_simple: PackedVector2Array = [
		Vector2.RIGHT*2600 + Vector2(0,-30), 
		Vector2.RIGHT*2600 + Vector2(0,30), 
		
		Vector2.RIGHT.rotated(0.14)* 150,
		Vector2.RIGHT.rotated(0.33)* 300, 
		
		Vector2.ZERO, 
		
		Vector2.RIGHT.rotated(-0.33) * 300, 
		Vector2.RIGHT.rotated(-0.14) * 150]

var hit_bien: PackedVector2Array = [
		Vector2.RIGHT*2600 + Vector2(0,-30), 
		Vector2.RIGHT*2600 + Vector2(0,30), 
		
		Vector2.RIGHT.rotated(0.14)* 150,
		Vector2.RIGHT.rotated(0.28)* 300, 
		
		Vector2.RIGHT.rotated(0.4)* 150,
		Vector2.RIGHT.rotated(0.79)* 300, 
		
		Vector2.ZERO, 
		
		Vector2.RIGHT.rotated(-0.79)* 300, 
		Vector2.RIGHT.rotated(-0.4)* 150,
		
		Vector2.RIGHT.rotated(-0.28) * 300, 
		Vector2.RIGHT.rotated(-0.14) * 150]

var hit_excellent: PackedVector2Array = [
		Vector2.RIGHT*2600 + Vector2(0,-30), 
		Vector2.RIGHT*2600 + Vector2(0,30), 
		
		Vector2.RIGHT.rotated(0.14)* 150,
		Vector2.RIGHT.rotated(0.28)* 300, 
		
		Vector2.RIGHT.rotated(0.44)* 150,
		Vector2.RIGHT.rotated(0.79)* 300, 
		
		Vector2.RIGHT.rotated(0.86)* 150,
		Vector2.RIGHT.rotated(1.31)* 300, 
		
		Vector2.ZERO, 
		
		Vector2.RIGHT.rotated(-1.31)* 300,
		Vector2.RIGHT.rotated(-0.86)* 150, 
		
		Vector2.RIGHT.rotated(-0.79)* 300, 
		Vector2.RIGHT.rotated(-0.44)* 150,
		
		Vector2.RIGHT.rotated(-0.28) * 300, 
		Vector2.RIGHT.rotated(-0.14) * 150]

var hit_smashed: PackedVector2Array = [
		Vector2.RIGHT*2600 + Vector2(0,-30), 
		Vector2.RIGHT*2600 + Vector2(0,30), 
		
		Vector2.RIGHT.rotated(0.14)* 150,
		Vector2.RIGHT.rotated(0.28)* 300, 
		
		Vector2.RIGHT.rotated(0.44)* 150,
		Vector2.RIGHT.rotated(0.79)* 300, 
		
		Vector2.RIGHT.rotated(0.95)* 150,
		Vector2.RIGHT.rotated(1.42)* 300, 
		
		Vector2.RIGHT.rotated(PI*0.5)* 150,
		Vector2.RIGHT.rotated(1.9)* 300, 
		
		Vector2.ZERO, 
		
		Vector2.RIGHT.rotated(-1.9)* 300,
		Vector2.RIGHT.rotated(-PI*0.5)* 150, 
		
		Vector2.RIGHT.rotated(-1.42)* 300,
		Vector2.RIGHT.rotated(-0.95)* 150, 
		
		Vector2.RIGHT.rotated(-0.79)* 300, 
		Vector2.RIGHT.rotated(-0.44)* 150,
		
		Vector2.RIGHT.rotated(-0.28) * 300, 
		Vector2.RIGHT.rotated(-0.14) * 150]

@onready var hits:= [hit_simple, hit_bien, hit_excellent, hit_smashed]

func fx_hit(agent: AgentPhysique, hit_type: int, angle: Vector2, duration: int):
	position = agent.position
	activated_hit = hits[hit_type].duplicate()
	color = agent.crew.color
	rotation = angle.angle()
	index = duration
	scale = agent.scale
	queue_redraw()
	

func _process(delta: float) -> void:
	if index >= 0:
		index -= 1
	elif !activated_hit.is_empty():
		queue_redraw()
		activated_hit.clear() 
	
	

func _draw() -> void:
	if !activated_hit.is_empty():
		draw_colored_polygon(activated_hit, color)
