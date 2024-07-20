class_name Bullet
extends Area3D


var velocity: Vector3 = Vector3.ZERO


func _ready() -> void:
	var expiration_timer: Timer = Timer.new()
	add_child(expiration_timer)
	expiration_timer.wait_time = 10
	expiration_timer.one_shot = true
	expiration_timer.timeout.connect(expire)
	expiration_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	global_transform.origin += velocity * delta


func expire() -> void:
	queue_free()


func _on_body_entered(body) -> void:
	if body.find_child("Health"):
		body.health.take_damage(10)
	queue_free()


func _on_area_entered(area):
	if area.find_child("Health"):
		area.health.take_damage(10)
		queue_free()
