extends Node

var current_idx:= -1
@export var players_on: Array[Player]

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
		

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("DEBUG_create_ball"):
		DEBUG_played_player_get_ball()


func DEBUG_played_player_get_ball():
	var nouveau_ballon := scene_ballon.instantiate()
	nouveau_ballon.name = "ballon_0"
	nouveau_ballon.apply_physics = false
	%BoiteBallons.add_child(nouveau_ballon)
	%BoiteBallons.ballon_actif = nouveau_ballon
	nouveau_ballon.holding_player = players_on[current_idx]
	players_on[current_idx].ballon_tenu = nouveau_ballon

func _ready() -> void:
	change_played_player(0)

func _process(delta: float) -> void:
	
	input_getter.updateInput(delta)
	
	
	if input_getter.input_changement!= 0:
		if input_getter.input_changement > 0:
			change_played_player(current_idx + int(input_getter.input_changement))
		else:
			change_played_player(current_idx + int(input_getter.input_changement))
	
	if input_getter.input_deplacement != Vector2.ZERO:
		players_on[current_idx].deplacement(input_getter.input_deplacement)
	
	if input_getter.input_jump:
		players_on[current_idx].tryJump(input_getter.input_jump)
	
	if input_getter.input_pass: 
		players_on[current_idx].tryPass(input_getter.input_pass)
	
	if input_getter.input_shoot:
		players_on[current_idx].tryShoot(input_getter.input_shoot)
	
	players_on[current_idx].updateCharges(input_getter.charge_jump, input_getter.charge_pass, input_getter.charge_shoot)
	
