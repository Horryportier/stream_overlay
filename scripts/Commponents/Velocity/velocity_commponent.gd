class_name VelocityCommponent
extends Node

@export var initial_velocity: Vector2 
@export var smoothing_exponent: float = -20
@export_group("rigid body interaction")
@export var push_force: float = 10
@export var eneble_pushing: bool = false

var velocity: Vector2:
	set(val):
		if val != velocity:
			velocity = val
			if agent:
				agent.velocity = velocity
var target_velocity: Vector2

var locked: bool = false

var agent: CharacterBody2D


func _ready() -> void:
	target_velocity = initial_velocity

func _enter_tree() -> void:
	agent = get_parent()

func _physics_process(delta: float) -> void:
	velocity = velocity.lerp(target_velocity, 1.0 - exp(smoothing_exponent * delta))
	_move_and_silde()
	
func _move_and_silde() -> void:
	if !eneble_pushing:
		agent.move_and_slide()
		return
	if agent.move_and_slide(): # true if collided
		for i in agent.get_slide_collision_count():
			var col = agent.get_slide_collision(i)
			if col.get_collider() is RigidBody2D:
				col.get_collider().apply_force(col.get_normal() * -push_force)

func set_velocity(v: Vector2) -> void:
	if locked:
		return
	target_velocity = v
