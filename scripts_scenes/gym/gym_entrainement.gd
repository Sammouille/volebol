extends GymLocal


@export var scene_machine: PackedScene
var machine: MachineBallon

func _ready() -> void:
	creerCrewHandlers(6, 0, true)
	if scene_machine:
		machine = scene_machine.instantiate()
		machine.crew = equipe_droite
		%Terrain.add_child(machine)
		machine.position = Vector2(480, 0)
		crewhandlers.append(machine)

func echangeCote():
	for i in crewhandlers:
		if i is CrewHandler:
			for j in i.players:
				j.position.x = -j.position.x
		elif i is MachineBallon:
			i.gauche = !i.gauche
			i.position.x = -i.position.x
	crewhandlers.append(crewhandlers.pop_front())
	equipe_gauche = crewhandlers[0].crew
	equipe_droite = crewhandlers[1].crew
