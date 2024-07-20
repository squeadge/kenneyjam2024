class_name Cargo
extends Area3D


enum State {ATTACHED_MOVING, ATTACHED_STOPPED, DETACHED}

var state = State.DETACHED
var target: Node3D

@onready var health: Health = $Health

# Called when the node enters the scene tree for the first time.
func _ready():
	health.health_depleted.connect(handle_health_depleted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if state == State.DETACHED:
		return
	elif state == State.ATTACHED_MOVING:
		if !is_instance_valid(target) or target == null:
			state = State.DETACHED
			return
		global_transform.origin = global_transform.origin.slerp(target.global_transform.origin, delta * 2)
		look_at(target.global_transform.origin)
		


func _on_body_entered(body):
	if state == State.DETACHED:
		if body.find_child("Health"):
			state = State.ATTACHED_MOVING
			target = body.update_caboose(self)
			if !is_instance_valid(target):
				target = body
		else:
			queue_free()
	elif state == State.ATTACHED_MOVING:
		if body.find_child("Health"):
			body.health.take_damage(1000)


func handle_health_depleted() -> void:
	queue_free()
