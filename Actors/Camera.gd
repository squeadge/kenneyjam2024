class_name PlayerCamera
extends Node3D


@export var pos_lerp_speed: float = 40.0
@export var turn_lerp_speed: float = 8.0
@export var target_path : NodePath
@export var offset: Vector3 = Vector3(0, 3, 10)
@export var rotation_speed: Vector3 = Vector3(PI/2, PI, PI/2)
@export var invert_y: bool = true
@export var invert_x: bool = true

@onready var camera: Camera3D = $Camera


var target: Node = null
var new_offset: Vector3 = Vector3.ZERO

var xy_rotation: Vector2 = Vector2.ZERO
var lerp_speed: float = 5.0


func _ready() -> void:
	if target_path:
		target = get_node(target_path)
	
	offset = Vector3(0, 3, 6)
	camera.global_transform.origin = global_transform.translated_local(offset).origin
	global_transform.origin = target.global_transform.origin


func _physics_process(delta: float) -> void:
	if !target or !is_instance_valid(target):
		return
	global_transform.origin = target.global_transform.origin
	xy_rotation = Input.get_vector("camera_up", "camera_down", "camera_left", "camera_right", .3)
	if xy_rotation != Vector2.ZERO:
		rotate_camera(xy_rotation, delta)
		
	else:
		new_offset = Vector3(offset.x, offset.y, offset.z + (target.velocity.length()/target.max_speed) * offset.z)
		camera.global_transform.origin = camera.global_transform.origin.lerp(global_transform.translated_local(new_offset).origin, turn_lerp_speed * delta)
		
		var basis_quat: Quaternion = Quaternion(global_transform.basis.orthonormalized())
		var target_basis: Basis = target.global_transform.basis
		var target_quat: Quaternion = Quaternion(target_basis.orthonormalized())
		global_transform.basis = Basis(basis_quat.slerp(target_quat, lerp_speed * delta))


func rotate_camera(input: Vector2, delta: float) -> void:
	new_offset = Vector3(offset.x, offset.y, offset.z * 2)
	camera.global_transform.origin = camera.global_transform.origin.lerp(global_transform.translated_local(new_offset).origin, turn_lerp_speed * delta)
	# Rotate gimbal around x and y axis
	input.y = -input.y 
	input.x = -input.x 
	
	var basis_quat: Quaternion = Quaternion(global_transform.basis.orthonormalized())
	var target_basis: Basis = target.global_transform.basis
	var rot_speed: Vector2 = Vector2(rotation_speed.x, rotation_speed.y)
	if input.x < 0:
		rot_speed.x = rotation_speed.z
	var x_rotation: float = clamp(rot_speed.x * input.x * 1.3, -rot_speed.x, rot_speed.x)
	target_basis = target_basis.rotated(target.global_transform.basis.x, 
		x_rotation).orthonormalized()
	var y_rotation: float = clamp(rot_speed.y * input.y * 1.3, -rot_speed.y, rot_speed.y)
	target_basis = target_basis.rotated(target.global_transform.basis.y, y_rotation).orthonormalized()
	var target_quat: Quaternion = Quaternion(target_basis.orthonormalized())
	global_transform.basis = Basis(basis_quat.slerp(target_quat, lerp_speed  * delta))
