extends Node

signal player_connected(peer_id,player_info)
signal server_started()
signal player_disconnected(peer_id)
signal server_disconnected()
signal transfer_input(i_c,i_d,f_j,c_p,i_p,c_s,i_s,r)

const PORT = 7000
const DEFAULT_SERV_ID = "127.0.0.1"
const MAX_CO = 8

var players = {}

var player_info = "name"

var players_loaded = 0

@onready var multisetupper = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_valid)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func join_game(addr,player_name):
	if addr == "":
		addr = DEFAULT_SERV_ID
	player_info = player_name
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(addr, PORT)
	if error :
		return error
	multiplayer.multiplayer_peer = peer
	print(peer)
	
func create_game(player_name):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT,MAX_CO)
	player_info = player_name
	if error :
		return error
	multiplayer.multiplayer_peer = peer
	players[1] = player_info
	server_started.emit()
#	player_connected.emit(1, player_info)
	#print(players)
	
func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()
	
## TODO : The "reliable" might be change to improve performance. Might also be
## a good idea to select a specific channel
@rpc("call_local","reliable")
func load_game(nb_joueureuse,crew_size,ids):
	get_parent().start_game(nb_joueureuse,crew_size,ids)

@rpc("any_peer","call_local","reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded = players_loaded + 1
		
func _on_player_connected(id):
	print("PLAYER_CONNECTED ID : ",id)
	_register_player.rpc_id(id,player_info)


@rpc("any_peer","reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_info)
	#print("REGISTERED : " ,players, " ", new_player_id)
	
	
func _on_connected_valid():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	server_started.emit()
	#player_connected.emit(peer_id, player_info)
	#print("CONNECTED : ", players, " ",peer_id)
	
func _on_connected_fail():
	remove_multiplayer_peer()
	
func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)

func _on_server_disconnected():
	remove_multiplayer_peer()
	players.clear()
	server_disconnected.emit()

@rpc("call_local","any_peer","reliable")
func setup_player():
	pass
	
@rpc("call_local","any_peer","reliable")
func get_input(i_c,i_d,f_j,c_p,i_p,c_s,i_s,r,d):
	multisetupper.handle_online_input(multiplayer.get_remote_sender_id(),i_c,i_d,f_j,c_p,i_p,c_s,i_s,r,d)

@rpc("call_remote","any_peer","reliable")
func transfer_position(array_player,array_ballon):
	multisetupper.handle_position_info(array_player,array_ballon)

@rpc("call_local","any_peer", "reliable")
func creerBallon():
	multisetupper.gym_multi.nouveauService()
