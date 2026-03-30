extends Control

@export var equipe_gauche: Crew
@export var equipe_droite: Crew

var score_gauche:= 0
var score_droite:= 0

func actualiserTexte():
	%ScoreGauche.text = "[center][font_size=777][color="+ equipe_gauche.color.to_html() + "][outline_color="+ equipe_gauche.libero_color.to_html() + "][outline_size=131]" + str(score_gauche)
	%ScoreDroite.text = "[center][font_size=777][color="+ equipe_droite.color.to_html() + "][outline_color="+ equipe_droite.libero_color.to_html() + "][outline_size=131]" + str(score_droite)

func point(gauche: bool):
	if gauche:
		score_gauche += 1
	else:
		score_droite += 1
	actualiserTexte()
