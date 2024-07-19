class_name Player
extends CharacterBody3D


var forward_thrust: float = 100.0
var pitch_input: float = 0.0
var roll_input: float = 0.0
var yaw_input: float = 0.0
var thrust_turn_factor: float = 0.0

@onready var health: Health = $Health
@onready var input: PlayerInput = $PlayerInput

@export var max_speed: float = 250.0
@export var min_speed: float = 0.0
@export var base_speed: float = 100.0
@export var optimal_speed: float = 100.0
@export var acceleration: float = 0.1
@export var pitch_speed: float = 0.8
@export var roll_speed: float = 2.5
@export var yaw_speed: float = 0.25
@export var max_health: float = 250


func _ready() -> void:
	velocity = -global_transform.basis.z * forward_thrust
	
	health.health = max_health
	health.health_depleted.connect(handle_health_depleted)


func _physics_process(delta: float) -> void:
		handle_movement(delta)
		var collide: bool = move_and_slide()
		handle_collision(collide)


func handle_collision(collided: bool) -> void:
	if collided:
		destroy()


func handle_health_depleted() -> void:
	destroy()
	


func destroy() -> void:
	queue_free()


func handle_movement(delta: float) -> void:
	get_input(delta)
	rotate_plane(delta)
	calculate_velocity(delta)


func rotate_plane(delta: float) -> void:
	thrust_turn_factor = clamp(1.2 - (abs(optimal_speed - forward_thrust) / max_speed), .5, 1.0) * delta
	global_transform.basis = global_transform.basis.rotated(global_transform.basis.z, roll_input * roll_speed * thrust_turn_factor)
	global_transform.basis = global_transform.basis.rotated(global_transform.basis.x, pitch_input * pitch_speed * thrust_turn_factor)
	global_transform.basis = global_transform.basis.rotated(global_transform.basis.y, yaw_input * yaw_speed * thrust_turn_factor)
	global_transform.basis = global_transform.basis.orthonormalized()


func calculate_velocity(delta: float) -> void:
	var target_velocity: Vector3 = -(global_transform.basis.z).normalized() * forward_thrust
	velocity = velocity.slerp(target_velocity, 2.0 * delta)


func get_input(delta: float) -> void:
	if input.forward_thrust > 0:
		var throttle_strength: float = input.forward_thrust * (max_speed - base_speed)
		forward_thrust = lerp(forward_thrust, base_speed + throttle_strength, acceleration * delta)
	elif input.forward_thrust <  0:
		var throttle_strength: float = input.forward_thrust * (base_speed - min_speed)
		forward_thrust = lerp(forward_thrust, base_speed + throttle_strength, 2.0 * acceleration * delta)
	else:
		forward_thrust = lerp(forward_thrust, base_speed , acceleration * delta)
	pitch_input = lerp(pitch_input, input.pitch_input, 4.0 * delta)
	roll_input = lerp(roll_input, input.roll_input, 4.0 * delta) 
	yaw_input = lerp(yaw_input, input.yaw_input, 4.0 * delta) 
