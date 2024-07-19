extends Node3D

@onready var spawn_timer: Timer = $SpawnTimer

const Asteroid_Instantiator = preload("res://Environment/asteroid.tscn")



func spawn_asteroid() -> void:
	var asteroid: Asteroid = Asteroid_Instantiator.instantiate()
	add_child(asteroid)
	asteroid.global_transform.origin = global_transform.origin
	asteroid.velocity = Vector3.LEFT


func _on_spawn_timer_timeout() -> void:
	spawn_asteroid()
