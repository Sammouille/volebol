extends Node
class_name Jump

@onready var player : Player = get_parent()

@export_category("Jump")
@export var base_jump:= 0.08
@export var ccharge_jump: Curve
@export var max_charged_jump:= 0.05
@export var ccharge_jump_conversion: Curve
@export var mod_jump_conversion:= 0.001

func jump(charge: float, frame: int):
	var charged_power = 0.0
	var conversion_rate = 0.0
	if charge <= ccharge_jump.max_domain:
		#charged_power = ccharge_jump.sample_baked(charge) * max_charged_jump
		conversion_rate = ccharge_jump_conversion.sample_baked(charge)
	else:
		#charged_power = ccharge_jump.sample_baked(1.0) * h_max_charged_autopass
		conversion_rate = ccharge_jump_conversion.sample_baked(1.0)
	player.appliquerHImpulse(base_jump + charged_power + player.velocite.length() * conversion_rate * mod_jump_conversion)
	player.velocite *= 1.00 - conversion_rate
