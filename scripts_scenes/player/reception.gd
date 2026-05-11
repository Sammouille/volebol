extends Node

@export var vitesse_negation:= 30.0
@export var montee_prog:= 30.0

var ballon_recu: Ballon = null
var traj_initiale:= Vector2.ZERO

var angle_vise:= Vector2.ZERO



func updateReception(input_getter: InputGetter, delta: float):
	if input_getter.reception:
		if ballon_recu == null:
			if %Envergure.has_overlapping_areas():
				for zone_ballon in %Envergure.get_overlapping_areas():
					var ballon = zone_ballon.get_parent()
					if ballon is Ballon:
						angle_vise = %Forward.current_aim.normalized()
						get_parent().apply_physics = false
						print("reception")
						ballon_recu = ballon
						ballon_recu.apply_physics = false
						ballon_recu.h_velocite = -ballon_recu.h_velocite * ballon_recu.rebond * 0.5
						traj_initiale = ballon_recu.velocite
						get_tree().get_first_node_in_group("Camera").pression = true
		else:
			ballon_recu.velocite -= traj_initiale * vitesse_negation * delta
			print(ballon_recu.velocite)
			ballon_recu.h_velocite += montee_prog * delta
			print(ballon_recu.h_velocite)
	elif ballon_recu != null:
		get_tree().get_first_node_in_group("Camera").pression = false
		get_parent().apply_physics = true
		ballon_recu.apply_physics = true
		ballon_recu = null
