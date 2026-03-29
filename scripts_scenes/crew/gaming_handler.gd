extends Node2D

var current_idx:= -1
@onready var players_on:= get_children()

@export var scene_ballon: PackedScene

var input_getter:= InputGetter.new()

func change_played_player(player_idx: int):
	if current_idx != -1:
		players_on[current_idx].played = false
	if player_idx > -1 and player_idx < players_on.size():
		current_idx = player_idx
	elif player_idx < 0:
		current_idx = players_on.size()-1
	elif player_idx > players_on.size()-1:
		current_idx = 0
	players_on[current_idx].played = true
	move_child(players_on[current_idx], 5)
		

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("DEBUG_create_ball"):
		DEBUG_played_player_get_ball()


func DEBUG_played_player_get_ball():
	var nouveau_ballon := scene_ballon.instantiate()
	nouveau_ballon.name = "ballon_0"
	%BoiteBallons.add_child(nouveau_ballon)
	%BoiteBallons.ballon_actif = nouveau_ballon
	nouveau_ballon.active = true
	nouveau_ballon.holding_player = players_on[current_idx]
	players_on[current_idx].ballon_tenu = nouveau_ballon
	nouveau_ballon.hauteur = players_on[current_idx].hauteur + 140
	nouveau_ballon.actualiserScale()
	nouveau_ballon.apply_physics = false

func _ready() -> void:
	change_played_player(0)

func _process(delta: float) -> void:
	
	input_getter.updateInput(delta)
	
	
	if input_getter.input_changement!= 0:
		if input_getter.input_changement > 0:
			change_played_player(current_idx + int(input_getter.input_changement))
		else:
			change_played_player(current_idx + int(input_getter.input_changement))
	
	players_on[current_idx].updatePlayer(input_getter)
	
