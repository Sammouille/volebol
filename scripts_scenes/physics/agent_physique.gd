extends Node2D
class_name AgentPhysique

const SCALE_PROGRESSION = 1.0

var h_velocite:= 0.0
var h_acceleration:= 0.0

var velocite:= Vector2.ZERO
var acceleration:= Vector2.ZERO

@export var frottements_sol:= 0.2
@export var frottements_aerien:= 0.1
@export var hauteur:= 1.00
@export var force_grav:= 0.60
@export var rebond:= 0.9

var apply_physics:= true

var grounded:= false

@onready var zhonya:= get_tree().get_first_node_in_group("Zhonya")

func actualiserScale():
	scale = Vector2(1.0, 1.0) * (SCALE_PROGRESSION * hauteur)

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
		
		if hauteur > 1.03:
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
	if hauteur > 1.001:
		appliquerHForce(-force_grav * 0.5)

func checkRebonds():
	if hauteur < 0.99:
		hauteur = 1.0
		h_velocite = -h_velocite * rebond
		velocite *= rebond

func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		delta *= zhonya.delta_mod
		physicUpdate(delta)
