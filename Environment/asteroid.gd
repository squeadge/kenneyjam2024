class_name Asteroid
extends Area3D

var velocity: Vector3 = Vector3.ZERO
var rot_x: float = 0
var rot_y: float = 0
var rot_z: float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_transform.origin += velocity
	rotate_x(rot_x * delta)
	rotate_y(rot_y * delta)
	rotate_z(rot_z * delta)
