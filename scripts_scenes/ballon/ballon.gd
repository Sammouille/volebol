extends AgentPhysique
class_name Ballon

const SIZE:= 17

var active:= false

@export var last_crew: Crew
@export var couleur: Color

var holding_player: Player = null

var touched_ground:= false

var aimed_ratio:= 0.0
var aimed:= false


func _physics_process(delta: float) -> void:
	if touched_ground and velocite.length() == 0.0 and h_velocite == 0.0:
		z_index = -1
	
	
	if grounded and !touched_ground:
		touched_ground = true
		var impact:= Impact.new()
		get_parent().add_child(impact)
		impact.position = position
		impact.setup(last_crew.color)
		active = false
		get_parent().ballon_actif = null
		
	
	if absf(position.x) < 25.0 and hauteur > 200.0:
		print("
PASSAGE AU DESSUS FILET ======")
		print("hauteur ballon sur filet: " + str(hauteur))
	
	if holding_player != null:
		position = holding_player.position
		hauteur = holding_player.hauteur + 140
	else:
		super(delta)
