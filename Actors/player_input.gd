class_name PlayerInput
extends Node


var forward_thrust: float = 0.0
var pitch_input: float = 0.0
var roll_input: float = 0.0
var yaw_input: float = 0.0
var shooting: bool = false
var tracking_target: bool = false


# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	forward_thrust = Input.get_axis("throttle_down", "throttle_up")
	pitch_input = Input.get_axis("pitch_down", "pitch_up")
	roll_input = Input.get_axis("roll_right", "roll_left")
	yaw_input = Input.get_axis("yaw_right", "yaw_left")
	
	shooting = Input.is_action_pressed("shoot")
