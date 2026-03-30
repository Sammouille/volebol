extends Camera2D

var target: Node2D

var vitesse:= 3.0

var zoom_initial:= Vector2(0.8, 0.8)
var proportion_suivi:= 0.1
var limites:= Vector2(1800, 1350)

var last_pression:= false
var pression:= false
var proportion_pression:= 0.4
var zoom_pression:= Vector2(1.0,1.0)

var current_zoom:= Vector2(0.8, 0.8)
var current_proportion:= 0.1

var vitesse_changement:= 8.0

func _process(delta: float) -> void:
	if pression:
		current_proportion = lerpf(current_proportion, proportion_pression, vitesse_changement * delta)
		zoom = zoom.lerp(zoom_pression, vitesse_changement * delta)
	else:
		current_proportion = lerpf(current_proportion, proportion_suivi, vitesse_changement * delta)
		zoom = zoom.lerp(zoom_initial, vitesse_changement * delta)
	
	
	if target != null:
		if target.position > -limites and target.position < limites:
			position = position.lerp(target.position * current_proportion, vitesse* delta)
		else:
			target = null
	if target == null:
		position = position.lerp(Vector2.ZERO, vitesse * delta)
