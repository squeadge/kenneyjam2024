extends Node3D

const Asteroid_Instantiator = preload("res://Environment/asteroid.tscn")


func _ready() -> void:
	var spawn_timer: Timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = .1
	spawn_timer.timeout.connect(spawn_asteroid)
	spawn_timer.one_shot = false
	spawn_timer.start()


func spawn_asteroid() -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var asteroid: Asteroid = Asteroid_Instantiator.instantiate()
	add_child(asteroid)
	asteroid.global_transform.origin = global_transform.origin
	asteroid.global_transform.origin += global_transform.basis.z * rng.randf_range(-10000.0, 10000.0)
	asteroid.global_transform.origin += global_transform.basis.y * rng.randf_range(-400.0, 400.0)
	asteroid.velocity = Vector3(-(0.1 + rng.randf()) * 1000, rng.randf_range(-0.5, 0.5), rng.randf_range(-0.5, 0.5))
	asteroid.scale = Vector3.ONE * 500 * rng.randf()
	asteroid.rot_x = rng.randf_range(-1.0, 1.0)
	asteroid.rot_y = rng.randf_range(-1.0, 1.0)
	asteroid.rot_z = rng.randf_range(-1.0, 1.0)


