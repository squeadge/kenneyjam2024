class_name Asteroid
extends Area3D

var velocity: Vector3 = Vector3.ZERO
var rot_x: float = 0
var rot_y: float = 0
var rot_z: float = 0


func _ready() -> void:
	var expiration_timer: Timer = Timer.new()
	add_child(expiration_timer)
	expiration_timer.wait_time = 100
	expiration_timer.one_shot = true
	expiration_timer.timeout.connect(expire)
	expiration_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	global_transform.origin += velocity
	rotate_x(rot_x * delta)
	rotate_y(rot_y * delta)
	rotate_z(rot_z * delta)


func expire() -> void:
	queue_free()
