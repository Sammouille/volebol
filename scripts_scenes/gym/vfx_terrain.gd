extends Node2D

@export var mod_impact:= 1.0
@export var mod_himpact:= 0.6

var impacts: Array[Impact]

func marquerPoint(ballon: Ballon,  last_velocite: Vector2, last_h_velocite: float, crew: Crew):
	#var impact:= Impact.new()
	#add_child(impact)
	#impact.name = "impact_"+str(impacts.size())
	#impacts.append(impact)
	%Impacter.setup(crew.downed_color, crew.color, last_h_velocite*mod_himpact + last_velocite.length()*mod_impact, ballon.position)
