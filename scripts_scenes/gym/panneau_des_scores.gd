extends Control


@onready var gym:= get_tree().get_first_node_in_group("GymHandler")


func actualiserTexte():
	%ScoreGauche.text = "[center][font_size=777][color="+ gym.equipe_gauche.color.to_html() + "][outline_color="+ gym.equipe_gauche.libero_color.to_html() + "][outline_size=131]" + str(gym.score_gauche)
	%ScoreDroite.text = "[center][font_size=777][color="+ gym.equipe_droite.color.to_html() + "][outline_color="+ gym.equipe_droite.libero_color.to_html() + "][outline_size=131]" + str(gym.score_droite)
