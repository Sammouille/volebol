extends Node2D
class_name AgentPhysique

const SCALE_PROGRESSION = 1.3

var h_velocite:= .0
var h_acceleration:= .0

var velocite:= Vector2.ZERO
var acceleration:= Vector2.ZERO

@export var frottements_sol:= 0.2
@export var frottements_aerien:= 0.1
@export var hauteur:= 10.0
@export var force_grav:= 30.0
@export var rebond:= 0.9

var apply_physics:= true
var mod_grav:= 1.0
var grounded:= false

signal sol_touched

@onready var zhonya:= get_tree().get_first_node_in_group("Zhonya")

func actualiserScale():
	scale = Vector2(1.0, 1.0) * (SCALE_PROGRESSION * (hauteur*.01 +1.0))

func appliquerHImpulse(impulse: float):
	h_velocite += impulse

func appliquerImpulse(impulse: Vector2):
	velocite += impulse


func appliquerHForce(force: float):
	h_acceleration += force

func appliquerForce(force: Vector2):
	acceleration += force

func physicUpdate(delta: float):
	if apply_physics:
		pesenteur()
		checkRebonds()
		
		velocite += acceleration * delta
		acceleration = Vector2.ZERO
		position += velocite
		
		h_velocite += h_acceleration * delta
		h_acceleration = 0.0
		hauteur += h_velocite
		
		if hauteur > 5.0:
			grounded = false
			velocite -= velocite * frottements_aerien
			h_velocite -= h_velocite * frottements_aerien
		else:
			grounded = true
			velocite -= velocite * frottements_sol
			h_velocite -= h_velocite * frottements_sol
	else:
		velocite= Vector2.ZERO
		h_velocite= 0.0
	
	actualiserScale()
	

func pesenteur():
	if hauteur > 5.0:
		appliquerHForce(-force_grav * mod_grav)
		grounded = false

func _toucheSol():
	pass

func checkRebonds():
	if hauteur < 0.0:
		_toucheSol()
		hauteur = 0.0
		h_velocite = -h_velocite * rebond
		velocite *= rebond
		
		sol_touched.emit()
		
		if h_velocite < 5.0:
			grounded = true
			h_velocite = 0.0
			hauteur = 0.0

func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		delta *= zhonya.delta_mod
		physicUpdate(delta)
