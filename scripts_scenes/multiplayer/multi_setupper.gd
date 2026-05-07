extends Control

@export var gym_multi_packed : PackedScene
var gym_multi

@export var multiplayer_gate : Node

@export_group("Multi UI")
@export var multi_ui : Control
@export var multi_lobby : Control
@export var player_name : LineEdit
@export var player_list : VBoxContainer

var surf: PlancheSurf

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer_gate.server_started.connect(create_gym)
	multiplayer_gate.player_connected.connect(add_player_list)
	print(multiplayer.multiplayer_peer, " alors ", multiplayer.has_multiplayer_peer())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if multiplayer.is_server() and surf:
		print(surf.array_player,surf.array_ballons)
		multiplayer_gate.transfer_position.rpc(surf.array_player,surf.array_ballons)



func _on_create_game_pressed() -> void:
	if check_player_name():
		multiplayer_gate.create_game(player_name.text)


func _on_put_host_ip_addr_text_submitted(new_text: String) -> void:
	if check_player_name():
		multiplayer_gate.join_game(new_text,player_name.text)

func create_gym():
	gym_multi = gym_multi_packed.instantiate()
	multi_ui.hide()
	multi_lobby.show()
	print(multiplayer.multiplayer_peer, " alors ", multiplayer.has_multiplayer_peer())
	gym_multi.is_online = true
	gym_multi.multiplayer_gate = multiplayer_gate
	add_child(gym_multi)
	add_player_list(multiplayer_gate.player_info)


func _on_start_game_pressed() -> void:
	if multiplayer.is_server():
		surf = PlancheSurf.new()
		var nb_joueureuse = multiplayer_gate.players.size()
		var joueureuses_ids = multiplayer_gate.players.keys()
		multiplayer_gate.load_game.rpc(nb_joueureuse,6, joueureuses_ids)

func start_game(nb_joueureuse,crew_size,ids):
	if surf == null:
		surf = PlancheSurf.new()
	multi_lobby.hide()
	gym_multi.brancherBoite(surf)
	var gauche = true
	for i in nb_joueureuse:
		gym_multi.creerCrewHandlers(crew_size,ids[i],gauche, surf)
		gauche = !gauche

func handle_online_input(sender_id,i_c,i_d,f_j,c_p,i_p,c_s,i_s,r,d):
	for i in gym_multi.crewhandlers:
		if i.multiplayer_id == sender_id:
			i.input_getter.set_attributes(i_c,i_d,f_j,c_p,i_p,c_s,i_s,r)
			i.execute_input(d)


func handle_position_info(array_player,array_ballons):
	for i in surf.array_player.size():
		surf.array_player[i].set("position",array_player[i].get("position"))
		surf.array_player[i].set("hauteur",array_player[i].get("hauteur"))	
	for i in surf.array_ballons.size():
		surf.array_ballons[i].set("position",array_ballons[i].get("position"))
		surf.array_ballons[i].set("hauteur",array_ballons[i].get("hauteur"))
			#print(surf.array_player,surf.array_ballons)
func add_player_list(pname):
	var rtl = RichTextLabel.new()
	rtl.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rtl.text = pname
	player_list.add_child(rtl)

func check_player_name() -> bool:
	if player_name.text != "":
		return true
	else :
		return false
