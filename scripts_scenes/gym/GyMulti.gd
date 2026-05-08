extends Gym
class_name GyMulti

func brancherBoite(surf: PlancheSurf):
	%BoiteBallons.surf = surf

func send_input(i_c,i_d,f_j,c_p,i_p,c_s,i_s,r,d):
	multiplayer_gate.get_input.rpc_id(1,i_c,i_d,f_j,c_p,i_p,c_s,i_s,r,d)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("DEBUG_create_ball"):
		if multiplayer.is_server():
			multiplayer_gate.creerBallon.rpc()
		else:
			nouveauService()

func nouveauService():
	var nv_ballon: Ballon
	if service_gauche:
		nv_ballon = %BoiteBallons.playerGetBallon(crewhandlers[0].players[0])
	else:
		nv_ballon = %BoiteBallons.playerGetBallon(crewhandlers[1].players[0])
	
	ballon_actif = nv_ballon
	multiplayer_gate.ballon_actif = ballon_actif
