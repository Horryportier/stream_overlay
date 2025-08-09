class_name PathfindingCommponent
extends Node2D


@onready var agent: CharacterBody2D = get_parent()
@onready var velocity_commponent: VelocityCommponent = get_parent().get_node_or_null("VelocityCommponent")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D 
@onready var timer: Timer = $Timer

@export var movement_speed: float = 360
@export var enable: bool = true
@export var update_time: float = 1./20.
@export var raycast_length: float = 10
@export var force_multiplayer: float = 1
@export_flags_2d_physics var raycast_mask: int 

var velocity_modifier_fn: Callable = func(v: Vector2) -> Vector2: return v

func _ready() -> void:
	nav_agent.velocity_computed.connect(_on_safe_velocity)
	timer.wait_time = update_time
	timer.timeout.connect(_on_timeout)

func arive(pos: Vector2) -> void:
	nav_agent.target_position = pos
	if timer.is_stopped():
		timer.start()
		

func abord_move() -> void: 
	nav_agent.target_position = agent.global_position
	velocity_commponent.set_velocity(Vector2.ZERO)
	timer.stop()

func _on_safe_velocity(safe_velocity: Vector2) -> void:
		if nav_agent.is_navigation_finished(): 
			velocity_commponent.set_velocity(Vector2.ZERO)
			return
		velocity_commponent.set_velocity(safe_velocity)

func _on_timeout() -> void:
	if nav_agent.is_navigation_finished() or !enable:
		return
	var current_agent_position: Vector2 = agent.global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	nav_agent.velocity = velocity_modifier_fn.call((next_path_position - current_agent_position).normalized() * movement_speed)
