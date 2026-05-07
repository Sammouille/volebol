extends Gym
class_name GymLocal

func _ready() -> void:
	creerCrewHandlers(6, 0, true)
	creerCrewHandlers(6, -1, true)
