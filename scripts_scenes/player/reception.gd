extends Node

@export var vitesse_negation:= 30.0
@export var montee_prog:= 30.0

var ballon_recu: Ballon = null
var traj_initiale:= Vector2.ZERO

func updateReception(input_getter: InputGetter, delta: float):
	if input_getter.reception:
		if ballon_recu == null:
			if %Envergure.has_overlapping_areas():
				for zone_ballon in %Envergure.get_overlapping_areas():
					var ballon = zone_ballon.get_parent()
					if ballon is Ballon:
						print("prout")
						ballon_recu = ballon
						ballon_recu.apply_physics = false
						ballon_recu.h_velocite = 0.0
		else:
			ballon_recu.velocite -= traj_initiale * vitesse_negation * delta
			ballon_recu.h_velocite += montee_prog * delta
	elif ballon_recu != null:
		ballon_recu.apply_physics = true
