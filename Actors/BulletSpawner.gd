class_name BulletSpawner
extends Node3D

const Bullet_Instantiator: PackedScene = preload("res://Actors/bullet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.bullet_fired.connect(handle_bullet_fired)


func handle_bullet_fired(origin: Vector3, velocity: Vector3) -> void:
	var bullet: Bullet = Bullet_Instantiator.instantiate()
	add_child(bullet)
	bullet.look_at(bullet.global_transform.origin + velocity.normalized(), bullet.global_transform.basis.y)
	bullet.global_transform.origin = origin
	bullet.velocity = (velocity.length() + 600) * velocity.normalized()
