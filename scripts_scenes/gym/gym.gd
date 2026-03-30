extends Node2D

@export var equipe_gauche: Crew
@export var equipe_droite: Crew

@onready var vfx:= %VfxTerrain

var battle:= false

var ballon_actif: Ballon
var ballons_marques: Array[Ballon]
var ballons_echauffement: Array[Ballon]

func suiviNouveauBallon(ballon: Ballon):
	if battle:
		pass
	else:
		ballons_echauffement.append(ballon)
		%Camera2D.target = ballon

func marquerBallon(ballon: Ballon, last_velocite: Vector2, last_h_velocite: float):
	if ballon.touched:
		if ballon.position.x > -915 and ballon.position.x < 915 and ballon.position.y > -465 and ballon.position.y < 465:
			if ballon.position.x >= 0:
				point(equipe_gauche)
				%PanneauDesScores.point(true)
				vfx.marquerPoint(ballon, last_velocite, last_h_velocite, equipe_gauche)
			else:
				point(equipe_droite)
				%PanneauDesScores.point(false)
				vfx.marquerPoint(ballon, last_velocite, last_h_velocite, equipe_droite)
		else:
			if ballon.last_crew == equipe_gauche:
				point(equipe_droite)
				%PanneauDesScores.point(false)
				vfx.marquerPoint(ballon, last_velocite, last_h_velocite, equipe_droite)
			else:
				
				point(equipe_gauche)
				%PanneauDesScores.point(true)
				vfx.marquerPoint(ballon, last_velocite, last_h_velocite, equipe_gauche)


func point(equipe: Crew):
	pass
