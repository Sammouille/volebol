extends Resource

class_name PlancheSurf

var zindex_stop:= 0
var zstopped:= false

var array_ballons:= []

var dico_ballon_nul:= {
	"position" : Vector2.ZERO,
	"hauteur" : 0.0
}

var array_player:= []

var dico_player_nul:= {
	"position" : Vector2.ZERO,
	"hauteur" : 0.0,
	#"frame jump" : 0,
	#"charge passe" : 0.0,
	#"input passe" : 0.0,
	#"reception" : false,
	#"charge shoot" : 0.0,
	#"input shoot" : 0.0
}


func ajouterJoueureuse():
	var nv_dico:= dico_player_nul.duplicate()
	array_player.append(nv_dico)
	print(nv_dico)
	return nv_dico

func ajouterBallon():
	var nv_dico:= dico_ballon_nul.duplicate()
	array_ballons.append(nv_dico)
	return nv_dico
