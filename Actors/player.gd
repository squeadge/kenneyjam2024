class_name Player
extends CharacterBody3D


var forward_thrust: float = 50.0
var pitch_input: float = 0.0
var roll_input: float = 0.0
var yaw_input: float = 0.0
var thrust_turn_factor: float = 0.0

@onready var health: Health = $Health
@onready var input: PlayerInput = $PlayerInput
@onready var crosshair1: Sprite3D = $Crosshair1
@onready var crosshair2: Sprite3D = $Crosshair2

@export var max_speed: float = 200.0
@export var min_speed: float = 40.0
@export var base_speed: float = 80.0
@export var optimal_speed: float = 60.0
@export var acceleration: float = 0.05
@export var pitch_speed: float = 1.2
@export var roll_speed: float = 3.0
@export var yaw_speed: float = 0.4
@export var max_health: float = 250
@export var weapon_cooldown: float = .2

var weapon_cooling_down: bool = false
var cooldown_timer: Timer
var caboose: Cargo


func _ready() -> void:
	velocity = -global_transform.basis.z * forward_thrust
	
	health.health = max_health
	health.health_depleted.connect(handle_health_depleted)
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.wait_time = weapon_cooldown
	cooldown_timer.autostart = false
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(end_cooldown)


func _physics_process(delta: float) -> void:
		handle_movement(delta)
		var collide: bool = move_and_slide()
		handle_collision(collide)
		if input.shooting:
			shoot_gun()


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
	velocity = velocity.slerp(target_velocity, 3.5 * delta)


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


func shoot_gun() -> void:
	if weapon_cooling_down:
		return
	GlobalSignals.emit_signal("bullet_fired", crosshair1.global_transform.origin, (crosshair2.global_transform.origin - crosshair1.global_transform.origin).normalized() * velocity.length())
	weapon_cooling_down = true
	cooldown_timer.start()


func end_cooldown() -> void:
	weapon_cooling_down = false


func update_caboose(new_caboose: Cargo) -> Cargo:
	var old_caboose: Cargo = caboose
	caboose = new_caboose
	return old_caboose
