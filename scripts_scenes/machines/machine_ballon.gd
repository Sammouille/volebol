extends AgentPhysique
class_name MachineBallon

@export var libero:= false
@export var crew: Crew

@export var duree_replacement:= 0.3

var timer:= Timer.new()

var input_getter:= InputGetter.new()

@export var frequence:= 6.0:
	set(value):
		timer.wait_time = value
		frequence = value

@export var played:= true:
	set(value):
		if value:
			timer.start()
		else:
			timer.stop()
		played = value

var is_smashing:= false


func _ready() -> void:
	apply_physics = false
	timer.wait_time = frequence
	add_child(timer)
	timer.one_shot = false
	timer.timeout.connect(nouveauTir)
	if played:
		timer.start()

func nouveauTir():
	if !is_smashing:
		is_smashing = true
		
		var nv_pos:= Vector2(randi_range(300,1500), randi_range(-450,450))
		var nv_hauteur:= randi_range(0, 131)
		await get_tree().create_tween().tween_property(self, "position", nv_pos, duree_replacement).finished
		await get_tree().create_tween().tween_property(self, "hauteur", nv_hauteur, duree_replacement * 2.0).finished
		
		var nouveau_ballon: Ballon = %BoiteBallons.machineGetBallon(self)
		nouveau_ballon.hauteur = hauteur + randf_range(%Shoot.curve_hratio.min_domain, %Shoot.curve_hratio.max_domain)
		var puissance_tir:= randf_range(0.3, %Shoot.ccharge_shoot.max_domain * 1.2)
		await get_tree().create_tween().tween_property(input_getter, "charge_shoot", puissance_tir, puissance_tir).finished
		
		nouveau_ballon.apply_physics = true
		nouveau_ballon.holding_agent = null
		input_getter.input_shoot = input_getter.charge_shoot
		
		input_getter.charge_shoot = 0.0
		is_smashing = false
	
	

	

func _agent_process(delta: float):
	%Shoot.updateShoot(input_getter)
	
	if input_getter.input_shoot:
		input_getter.input_shoot = 0.0
