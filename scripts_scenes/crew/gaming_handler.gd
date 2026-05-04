extends Node2D
class_name CrewHandler

var current_idx:= -1
@onready var players_on:= get_children()
var players_pos = [Vector2(-700,300),
Vector2(-700,0),
Vector2(-700,-300),
Vector2(-200,300),
Vector2(-200,0),
Vector2(-200,-300),]

var input_getter:= InputGetter.new()
var player_scene = preload("res://scripts_scenes/player/player.tscn")
var is_online = false
var multiplayer_id := 1
var gauche := true
@onready var gym = get_parent().get_parent()

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
	if Input.is_action_just_pressed("DEBUG_create_ball") and multiplayer.is_server():
		%BoiteBallons.playerGetBallon(players_on[current_idx])

func _init(nb_membre := 6, _gauche := true,id := 1) -> void:
	gauche = _gauche
	multiplayer_id = id
	for i in nb_membre:
		var nv_player = player_scene.instantiate()
		nv_player.position = players_pos[i]
		if !gauche :
			nv_player.position.x = -nv_player.position.x
		add_child(nv_player)

func _ready() -> void:
	change_played_player(0)

func _process(delta: float) -> void:
	input_getter.updateInput(delta)
	if gym.is_online :
		gym.send_input(input_getter.input_changement,
		input_getter.input_deplacement,
		input_getter.frame_jump,
		input_getter.charge_pass,
		input_getter.input_pass,
		input_getter.charge_shoot,
		input_getter.input_shoot,
		input_getter.reception,
		delta)
	else :
		if input_getter.input_changement!= 0:
			if input_getter.input_changement > 0:
				change_played_player(current_idx + int(input_getter.input_changement))
			else:
				change_played_player(current_idx + int(input_getter.input_changement))
		
		players_on[current_idx].updatePlayer(input_getter, delta)

func execute_input(delta):
	if multiplayer.is_server():
		if input_getter.input_changement!= 0:
			if input_getter.input_changement > 0:
				change_played_player(current_idx + int(input_getter.input_changement))
			else:
				change_played_player(current_idx + int(input_getter.input_changement))
		
		players_on[current_idx].updatePlayer(input_getter, delta)

func change_is_online():
	if multiplayer.multiplayer_peer != null:	
		is_online = true
	else : 
		is_online = false
		
		
