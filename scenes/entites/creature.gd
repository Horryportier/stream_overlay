extends CharacterBody2D

@onready var line_parent: Node2D = %Tentacles
@onready var pathfinding_commponent: PathfindingCommponent= %PathfindingCommponent

@export var limbs_segment_lenght: float
@export var limbs_min_angle: float
@export var limbs_max_angle: float
@export var limbs_segment_count: int
@export var gravity_influance: Curve
@export var min_limb_target_distance: float


var limbs_nodes: Array
var limbs: Array[Array]
var joints: Array[PackedVector2Array]

var desired_targets: PackedVector2Array
var current_target: PackedVector2Array
var targets: PackedVector2Array
var libmbs_target_achived: float

var main_target: Vector2

@onready var limbs_len: = limbs_segment_lenght * limbs_segment_count

var joints_size: int

func _ready() -> void:
	pathfinding_commponent.velocity_modifier_fn = modifiy_velocity
	limbs_nodes = line_parent.get_children()
	targets.resize(limbs_nodes.size())
	desired_targets.resize(limbs_nodes.size())
	current_target.resize(limbs_nodes.size())
	joints_size = limbs_segment_count + 1
	for idx in limbs_nodes.size():
		var node_limbs: Array
		node_limbs.append([limbs_segment_lenght, deg_to_rad(-180), deg_to_rad(180), 0])
		desired_targets[idx] = global_position + (Vector2.from_angle(deg_to_rad(60)  * idx) * limbs_len)
		var node_joints: PackedVector2Array
		for i in limbs_segment_count - 1:
			node_limbs.append([limbs_segment_lenght, deg_to_rad(limbs_min_angle), deg_to_rad(limbs_max_angle), 0])
			node_joints.append(Vector2(limbs_segment_lenght * 1 , 0))
		limbs.append(node_limbs)
		node_joints.resize(node_limbs.size()+ 1)
		joints.append(node_joints)

func _physics_process(_delta: float) -> void:
	main_target = get_global_mouse_position()
	pathfinding_commponent.arive(main_target)
	var is_at_target_count: int = 0
	for idx in limbs_nodes.size():
		if is_at_target(idx):
			print("at_target")
			is_at_target_count += 1
		if global_position.distance_to(targets[idx]) > limbs_len:
			_update_limbs_target(idx)
		current_target[idx] = lerp(current_target[idx], targets[idx], 0.05)
		var res := FabirkConstrained._update(to_local(current_target[idx]), joints[idx], limbs[idx], Vector2.ZERO, limbs_len, limbs[idx].size())
		var new_points = res[0]
		limbs_nodes[idx].points = new_points
	libmbs_target_achived = remap(is_at_target_count, 0, limbs_nodes.size(), 0, 1)

func _update_limbs_target(idx: int) -> void:
	desired_targets[idx] = global_position +  (Vector2.from_angle(deg_to_rad(90)  * idx) * limbs_len)
	if NavigationServer2D.get_maps().is_empty():
		return
	var path: =  NavigationServer2D.map_get_path(NavigationServer2D.get_maps()[0], global_position, desired_targets[idx], true)
	var target: =  targets[idx] if path.is_empty() else path[path.size()-1]
	targets[idx] = target
	queue_redraw()

func _draw() -> void:
	draw_set_transform_matrix(global_transform.affine_inverse())
	draw_circle(get_global_mouse_position(), 10, Color.MAGENTA)
	draw_circle(global_position, 10, Color.RED)
	for target in targets:
		draw_circle(target, 10, Color.YELLOW)

func is_at_target(idx) -> bool: 
	return joints[idx][0].distance_to(targets[idx]) <= min_limb_target_distance

func modifiy_velocity(v: Vector2) -> Vector2:
	var new_v = Vector2(v.x, v.y * (get_gravity().y + gravity_influance.sample(libmbs_target_achived)))
	return new_v
