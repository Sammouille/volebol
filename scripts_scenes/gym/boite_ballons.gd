extends Node2D

@onready var gym:= get_tree().get_first_node_in_group("GymHandler")

@export var scene_ballon: PackedScene

var index_ballons:= 0

signal ballon_created(nouveau_ballon: Ballon)

func playerGetBallon(player: Player):
	var nouveau_ballon := scene_ballon.instantiate()
	nouveau_ballon.name = "ballon_"+str(index_ballons)
	index_ballons += 1
	add_child(nouveau_ballon)
	ballon_created.emit(nouveau_ballon)
	nouveau_ballon.active = true
	nouveau_ballon.holding_agent = player
	player.ballon_tenu = nouveau_ballon
	nouveau_ballon.hauteur = player.hauteur + 140
	nouveau_ballon.actualiserScale()
	nouveau_ballon.apply_physics = false

func machineGetBallon(machine: MachineBallon):
	var nouveau_ballon := scene_ballon.instantiate()
	nouveau_ballon.name = "ballon_"+str(index_ballons)
	index_ballons += 1
	add_child(nouveau_ballon)
	ballon_created.emit(nouveau_ballon)
	nouveau_ballon.active = true
	nouveau_ballon.holding_agent = machine
	nouveau_ballon.apply_physics = false
	return nouveau_ballon
	
