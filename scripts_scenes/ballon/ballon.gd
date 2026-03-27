extends AgentPhysique
class_name Ballon

const SIZE:= 10.0

@export var last_crew: Crew
@export var couleur: Color

var holding_player: Player = null

var touched_ground:= false

func _physics_process(delta: float) -> void:
	#print("Hauteur: %.2f m" % ((hauteur-1.0)*2.0))
	
	if grounded and !touched_ground:
		touched_ground = true
		var impact:= Impact.new()
		get_parent().add_child(impact)
		impact.position = position
		impact.setup(last_crew.color)
		
	
	if holding_player != null:
		position = holding_player.position
		hauteur = holding_player.hauteur + 0.5
	else:
		super(delta)
