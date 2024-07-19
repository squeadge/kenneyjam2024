class_name Health
extends Node

signal health_depleted()

@export var health: float

func take_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		health_depleted.emit()
