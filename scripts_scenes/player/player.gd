extends AgentPhysique
class_name Player


@export var crew: Crew

@export var libero:= false

@export var vitesse:= 50.0

@onready var jumper:= %Jump

@export_category("Handpass")
@export var base_handpass:= 400.0
@export var ccharge_handpass: Curve
@export var max_charged_handpass:= 200.0
@export var h_base_handpass:= 10.0
@export var h_ccharge_handpass: Curve
@export var h_max_charged_handpass:= 10.0

@export_category("Autopass")
@export var base_autopass:= 0.0
@export var ccharge_autopass: Curve
@export var max_charged_autopass:= 300.0
@export var h_base_autopass:= 10.0
@export var h_ccharge_autopass: Curve
@export var h_max_charged_autopass:= 10.0

@export_category("Shoot")
@export var base_shoot:= 800.0
@export var ccharge_shoot: Curve
@export var max_charged_shoot:= 800.0

var played:= false

var ballon_tenu: Ballon = null

func deplacement(direction: Vector2):
	if grounded:
		direction = direction.normalized()
		appliquerForce(direction * vitesse)

func tryJump(charge: float):
	if grounded:
		jumper.jump(charge)

func tryPass(charge: float):
	if ballon_tenu != null:
		autopass(charge)
	else:
		if %Envergure.has_overlapping_areas():
			for zone_ballon in %Envergure.get_overlapping_areas():
				var ballon = zone_ballon.get_parent()
				if ballon is Ballon:
					if ballon.hauteur >= hauteur+0.6 and ballon.hauteur <= hauteur+1.3:
						handPass(charge, ballon)
		

func handPass(charge: float, ballon: Ballon):
	var charged_power = 0.0
	if charge <= ccharge_handpass.max_domain:
		charged_power = ccharge_handpass.sample_baked(charge) * max_charged_handpass
	else:
		charged_power = ccharge_handpass.sample_baked(1.0) * max_charged_handpass
	ballon.h_velocite = 0.0
	ballon.appliquerImpulse(%Forward.current_aim.normalized()* (base_handpass + charged_power))
	
	if charge <= h_ccharge_handpass.max_domain:
		charged_power = h_ccharge_handpass.sample_baked(charge) * h_max_charged_handpass
	ballon.appliquerHImpulse(h_base_handpass + charged_power)


func autopass(charge: float):
	ballon_tenu.apply_physics = true
	ballon_tenu.holding_player = null
	var charged_power = 0.0
	if charge <= ccharge_autopass.max_domain:
		charged_power = ccharge_autopass.sample_baked(charge) * max_charged_autopass
	else:
		charged_power = ccharge_autopass.sample_baked(1.0) * max_charged_autopass
	ballon_tenu.appliquerImpulse(%Forward.current_aim.normalized() * (base_autopass + charged_power))
	
	charged_power = 0.0
	if charge <= h_ccharge_autopass.max_domain:
		charged_power = h_ccharge_autopass.sample_baked(charge) * h_max_charged_autopass
	else:
		charged_power = h_ccharge_autopass.sample_baked(1.0) * h_max_charged_autopass
	ballon_tenu.appliquerHImpulse(h_base_autopass + charged_power)
	
	ballon_tenu = null

func tryShoot(charge: float):
	if %Envergure.has_overlapping_areas():
		for zone_ballon in %Envergure.get_overlapping_areas():
			var ballon = zone_ballon.get_parent()
			if ballon is Ballon:
				if ballon.hauteur >= hauteur+0.7 and ballon.hauteur <= hauteur+1.4:
					shoot(charge, ballon)

func shoot(charge: float, ballon: Ballon):
	var charged_power = 1.0
	if charge <= ccharge_shoot.max_domain:
		charged_power = ccharge_shoot.sample_baked(charge) * max_charged_shoot
	else:
		charged_power = ccharge_shoot.sample_baked(1.0) * max_charged_shoot
	ballon.h_velocite = 0.0
	ballon.appliquerImpulse(%Forward.current_aim.normalized() * (base_shoot + charged_power))

func updateCharges(charge_jump: float, charge_pass: float, charge_shoot: float):
	if charge_shoot != 0.0:
		%Forward.charge = ccharge_shoot.sample_baked(charge_shoot)
	elif charge_pass != 0.0 and ballon_tenu == null:
		%Forward.charge = ccharge_handpass.sample_baked(charge_pass)
	elif charge_pass != 0.0:
		%Forward.charge = ccharge_autopass.sample_baked(charge_pass)
	else:
		%Forward.charge = 0.0
		

#func _process(delta: float) -> void:
	#if played:
		#print("Hauteur: %.2f m" % ((hauteur-1.0)*2.0))
		#print("Vitesse: %.2f m/s" % (velocite.length() * 1.2))
