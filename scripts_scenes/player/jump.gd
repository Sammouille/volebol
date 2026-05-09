extends Node
class_name Jump

@onready var player : Player = get_parent()

@export var squat_frames:= 7
@export var max_floating_frames:= 44
@export var small_jump:= 5
@export var sj_speed_to_height:= 0.3
@export var sj_hpulse:= 15.0
@export var big_jump:= 6
@export var bj_speed_to_height:= 0.5
@export var bj_hpulse:= 5.0


var is_squating:= false
var last_ground_velocity:= Vector2.ZERO
var high_jump:= false

var last_fj:= 0

func updateJump(input_getter: InputGetter, grounded: bool,):
	if input_getter.frame_jump == 0:
		if is_squating and grounded and last_fj > squat_frames:
			is_squating = false
			%Sprite.mod_taille = 1.0
			player.appliquerHImpulse(big_jump)
			if last_ground_velocity.length() != 0.0:
				if input_getter.input_deplacement == Vector2.ZERO:
					player.appliquerHImpulse(last_ground_velocity.length() * bj_speed_to_height)
				else:
					player.appliquerForce(last_ground_velocity.length() * input_getter.input_deplacement * bj_hpulse)
		
		# SMALL JUMP (input laché avant la fin du squat)
		if is_squating and grounded:
			is_squating = false
			%Sprite.mod_taille = 1.0
			player.appliquerHImpulse(small_jump)
			if input_getter.input_deplacement == Vector2.ZERO:
				player.appliquerHImpulse(last_ground_velocity.length() * sj_speed_to_height)
			else:
				player.appliquerForce(last_ground_velocity.length() * input_getter.input_deplacement * sj_hpulse)
		
		last_ground_velocity = Vector2.ZERO
		player.mod_grav = 1.0
		
		# SQUAT
	elif input_getter.frame_jump == 1:
		is_squating = true
		last_ground_velocity = player.velocite
		player.mod_grav = 0.6
		%Sprite.mod_taille = lerpf(%Sprite.mod_taille, 0.8, 0.3)
		
	
	elif input_getter.frame_jump == max_floating_frames:
		player.mod_grav = 1.0
	
	elif input_getter.frame_jump <= squat_frames:
		%Sprite.mod_taille = lerpf(%Sprite.mod_taille, 0.8, 0.3)
	
	last_fj = input_getter.frame_jump
	#var charged_power = 0.0
	#var conversion_rate = 0.0
	#if charge <= ccharge_jump.max_domain:
		##charged_power = ccharge_jump.sample_baked(charge) * max_charged_jump
		#conversion_rate = ccharge_jump_conversion.sample_baked(charge)
	#else:
		##charged_power = ccharge_jump.sample_baked(1.0) * h_max_charged_autopass
		#conversion_rate = ccharge_jump_conversion.sample_baked(1.0)
	#player.appliquerHImpulse(base_jump + player.velocite.length() * conversion_rate * mod_jump_conversion)
	#player.velocite *= 1.00 - conversion_rate
