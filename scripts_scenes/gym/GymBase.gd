extends Node2D
class_name Gym


@export var equipe_gauche: Crew
@export var equipe_droite: Crew

@onready var vfx:= %VfxTerrain

var score_gauche:= 0
var set_gauche:= 0
var score_droite:= 0
var set_droite:= 0

var service_gauche:= true

var is_online = false
var multiplayer_gate : Node

var tie_break = false

var crewhandlers = []
var ballon_actif: Ballon
var ballons_marques: Array[Ballon]
var ballons_echauffement: Array[Ballon]

func creerCrewHandlers(nb_membre : int,id : int, _gauche := true, surf: PlancheSurf = null):
	var nv_crew: CrewHandler
	
	if _gauche:
		nv_crew = CrewHandler.new(nb_membre,_gauche,id, equipe_gauche, surf)
		nv_crew.crew = equipe_gauche
	else:
		nv_crew = CrewHandler.new(nb_membre,_gauche,id, equipe_droite, surf)
		nv_crew.crew = equipe_droite
	
	crewhandlers.append(nv_crew)
	%Terrain.add_child(nv_crew)

func nouveauService():
	var nv_ballon: Ballon
	if service_gauche:
		nv_ballon = %BoiteBallons.playerGetBallon(crewhandlers[0].players[0])
	else:
		nv_ballon = %BoiteBallons.playerGetBallon(crewhandlers[1].players[0])
	
	ballon_actif = nv_ballon
		

# Jcrois cette fonction est jamais utilisée
func suiviNouveauBallon(ballon: Ballon):
	ballons_echauffement.append(ballon)
	%Camera2D.target = ballon

func marquerBallon(ballon: Ballon, last_velocite: Vector2, last_h_velocite: float):
	if ballon.touched:
		if ballon.position.x > -915 and ballon.position.x < 915 and ballon.position.y > -465 and ballon.position.y < 465:
			if ballon.position.x >= 0:
				point(equipe_gauche)
				vfx.marquerPoint(ballon, last_velocite, last_h_velocite, equipe_gauche)
			else:
				point(equipe_droite)
				vfx.marquerPoint(ballon, last_velocite, last_h_velocite, equipe_droite)
		else:
			if ballon.last_crew == equipe_gauche:
				point(equipe_droite)
				vfx.marquerPoint(ballon, last_velocite, last_h_velocite, equipe_droite)
			else:
				point(equipe_gauche)
				vfx.marquerPoint(ballon, last_velocite, last_h_velocite, equipe_gauche)

func echangeCote():
	for i in crewhandlers:
		for j in i.players:
			j.position.x = -j.position.x
	crewhandlers.append(crewhandlers.pop_front())
	equipe_gauche = crewhandlers[0].crew
	equipe_droite = crewhandlers[1].crew

func point(equipe: Crew):
	if equipe.crew_handler:
		equipe.crew_handler.rotationJoueureuses()
	if equipe == equipe_gauche:
		score_gauche += 1
		if score_gauche >= 25 or (tie_break and score_gauche >= 15):
			if score_droite <= score_gauche-2:
				finSet(equipe)
		service_gauche = true
	elif equipe == equipe_droite:
		score_droite += 1
		if score_droite >= 25 or (tie_break and score_droite >= 15):
			if score_gauche <= score_droite-2:
				finSet(equipe)
		service_gauche = false
	
	%PanneauDesScores.actualiserTexte()

func finSet(equipe: Crew):
	score_droite = 0
	score_gauche = 0
	service_gauche = true
	if equipe == equipe_gauche:
		set_gauche+= 1
		if set_gauche == 3:
			finMatch(equipe)
		elif set_droite == 2 and set_gauche == 2:
			tie_break = true
	elif equipe == equipe_droite:
		set_droite+= 1
		if set_droite == 3:
			finMatch(equipe)
		elif set_droite == 2 and set_gauche == 2:
			tie_break = true
	echangeCote()

func finMatch(equipe: Crew):
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("DEBUG_create_ball"):
		nouveauService()
