class_name Asteroid
extends Area3D

var velocity: Vector3 = Vector3.ZERO
var rot_x: float = 0
var rot_y: float = 0
var rot_z: float = 0

var initial_origin: Vector3

@onready var health: Health = $Health

func _ready() -> void:
	#var expiration_timer: Timer = Timer.new()
	#add_child(expiration_timer)
	#expiration_timer.wait_time = 50
	#expiration_timer.one_shot = true
	#expiration_timer.timeout.connect(expire)
	#expiration_timer.start()
	initial_origin = global_transform.origin
	health.health_depleted.connect(handle_health_depleted)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	global_transform.origin += velocity * delta
	rotate_x(rot_x * delta)
	rotate_y(rot_y * delta)
	rotate_z(rot_z * delta)
	
	if (global_transform.origin - initial_origin).length() > 30000:
		queue_free()


func expire() -> void:
	queue_free()


func _on_body_entered(body):
	if body.find_child("Health"):
		body.health.take_damage(1000)
	queue_free()


func _on_area_entered(area):
	if area.find_child("Health"):
		area.health.take_damage(1000)
		queue_free()


func handle_health_depleted() -> void:
	queue_free()
