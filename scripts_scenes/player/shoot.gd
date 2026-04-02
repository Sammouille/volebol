extends Node

@onready var player : AgentPhysique = get_parent()

@export var curve_hratio: Curve
@export var max_hgain:= 20.0

@export_category("Shoot")
@export var base_shoot:= 10.0
@export var ccharge_shoot: Curve
@export var max_charged_shoot:= 20.0

@export var mod_recalibrage_distance:= 50.0
@export var mod_recalibrage_hauteur:= 2.0
@export var mod_speed_supression = 2.0

var ballon_vise: Ballon

func updateShoot(input_getter: InputGetter):
	if input_getter.charge_shoot != 0.0:
		%Forward.charge = ccharge_shoot.sample_baked(input_getter.charge_shoot)
		tryLockBallon()
		if ballon_vise != null:
			ballon_vise.aiming_crew = player.crew
			if ballon_vise.hauteur < curve_hratio.max_domain + player.hauteur and ballon_vise.hauteur > curve_hratio.min_domain + player.hauteur:
				ballon_vise.aimed = true
				ballon_vise.aimed_ratio = curve_hratio.sample_baked(ballon_vise.hauteur - player.hauteur)
			else:
				ballon_vise.aimed = false
	else:
		%Forward.charge = ccharge_shoot.sample_baked(input_getter.charge_shoot)
	
	if input_getter.input_shoot:
		tryShoot(input_getter.input_shoot)

func tryLockBallon():
	if %Envergure.has_overlapping_areas():
		for zone_ballon in %Envergure.get_overlapping_areas():
			var ballon = zone_ballon.get_parent()
			if ballon is Ballon:
				if ballon.active:
					ballon_vise = ballon
	else:
		if ballon_vise != null:
			ballon_vise.aimed = false
			ballon_vise.aimed_ratio = 0.0
		ballon_vise = null

func tryShoot(charge: float):
	if %Envergure.has_overlapping_areas():
		for zone_ballon in %Envergure.get_overlapping_areas():
			var ballon = zone_ballon.get_parent()
			if ballon is Ballon:
				if ballon.hauteur < curve_hratio.max_domain + player.hauteur and ballon.hauteur > curve_hratio.min_domain + player.hauteur:
					if ballon.active:
						shoot(charge, ballon)

func shoot(charge: float, ballon: Ballon):
	ballon.touched = true
	ballon.last_crew = player.crew
	var charged_power: float
	if charge <= ccharge_shoot.max_domain:
		charged_power = ccharge_shoot.sample_baked(charge) * max_charged_shoot
	else:
		charged_power = ccharge_shoot.sample_baked(1.0) * max_charged_shoot
		
	var hauteur_frappe = ballon.hauteur - player.hauteur
	var height_power: float
	if hauteur_frappe <= curve_hratio.max_domain:
		height_power = curve_hratio.sample_baked(hauteur_frappe) * max_hgain
	else:
		height_power = curve_hratio.sample_baked(1.0) * max_hgain
	ballon.h_velocite = 0.0
	
	var total_power: Vector2 = %Forward.current_aim.normalized() *(base_shoot + charged_power + height_power)
	
	var estimated_frames_to_net:= absi(ballon.position.x / (total_power.x * 0.9))
	
	var recalibrage_distance:= estimated_frames_to_net * mod_recalibrage_distance
	var recalibrage_hauteur: float = ((243.0 - (hauteur_frappe + player.hauteur))/ (estimated_frames_to_net * 0.5)) * mod_recalibrage_hauteur
	if height_power != max_hgain:
		recalibrage_hauteur+= max_hgain - height_power
	if total_power.y != 0.0:
		recalibrage_hauteur -= absf(total_power.normalized().y * 12.0)
	var recalibrage = minf(recalibrage_distance + recalibrage_hauteur, total_power.length())
	
	total_power = total_power.normalized() * (maxf(total_power.length() - recalibrage*mod_speed_supression, base_shoot))
	
	print(" XXX NOUVELLE FRAPPE XXX")
	print("
hauteur player: " + str(player.hauteur) + "
surrelevation ballon: " + str(hauteur_frappe) + "
frames estimées avant filet: " + str(estimated_frames_to_net))
	print("
RECALIBRAGE =========")
	print("distance up: "+str(recalibrage_distance) + "
hauteur up: "+str(recalibrage_hauteur) + "
puissance horizontale: "+str(total_power))
	
	ballon.appliquerImpulse(total_power)
	ballon.appliquerHImpulse(recalibrage)
	print("
PUISSANCE ==========")
	print("charge shoot: "+ str(charged_power))
	print("hauteur shoot: "+ str(height_power))
	player.zhonya.smashStop(total_power.length(), recalibrage_hauteur, player, total_power.normalized())
	ballon.aimed = false
	ballon.aimed_ratio = 0.0
