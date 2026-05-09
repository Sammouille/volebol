extends AgentPhysique
class_name Ballon



var last_hauteur:= 10.0

var touched:= false

var active:= false

@export var aiming_crew: Crew
@export var last_crew: Crew
@export var couleur: Color

var holding_agent: AgentPhysique = null

var touched_ground:= false

var aimed_ratio:= 0.0
var aimed:= false

signal disparu(ballon_disparu: Ballon)

@onready var gym:= get_tree().get_first_node_in_group("GymHandler")

func _ready() -> void:
	last_hauteur = hauteur

func _toucheSol():
	if !touched_ground:
		touched_ground = true
		active = false
		gym.marquerBallon(self, velocite, h_velocite)
		if !dico.is_empty():
			print("PASSE T(ON PAR ICI)")
			if multiplayer.is_server():
				gym.multiplayer_gate.scorePoint.rpc()

func disparition():
	await get_tree().create_tween().tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.3).finished
	disparu.emit(self)
	queue_free()

func _agent_process(delta: float):
	#if !apply_physics:
		#print(apply_physics)
	if touched_ground and velocite.length() < 0.3 and h_velocite < 0.1:
		z_index = -1
		disparition()
		
	
	#if velocite.length() >= 4.0:
		#print(velocite.length())
	
	if absf(position.x) < 20.0:
		print("
PASSAGE AU NIVEAU DU FILET ======")
		print("hauteur ballon sur filet: " + str(hauteur))
		if hauteur > 200.0 and hauteur < 220.0:
			if h_velocite < 0.0:
				h_velocite = -h_velocite * rebond * 0.5
				velocite *= rebond * 0.5
			else:
				velocite.x = -velocite.x
		elif hauteur < 220.0:
			velocite.x = -velocite.x
			
	
	if holding_agent != null:
		if holding_agent is Player:
			hauteur = holding_agent.hauteur + 140
		position = holding_agent.position
		apply_physics = false
	
	last_hauteur = hauteur
	#elif !apply_physics:
		#apply_physics = true
