extends Node2D

var current_idx:= -1
@onready var players_on:= get_children()

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
		%BoiteBallons.playerGetBallon(players_on[current_idx])

func _ready() -> void:
	change_played_player(0)

func _process(delta: float) -> void:
	input_getter.updateInput(delta)
	
	
	if input_getter.input_changement!= 0:
		if input_getter.input_changement > 0:
			change_played_player(current_idx + int(input_getter.input_changement))
		else:
			change_played_player(current_idx + int(input_getter.input_changement))
	
	players_on[current_idx].updatePlayer(input_getter, delta)
