class_name ComponentHealth
extends Node

signal max_health_changed(new_value: float)
signal current_health_changed(new_value: float)
signal health_depleted()

@export var max_health := 100.0:
	set(value):
		max_health = value
		max_health_changed.emit(value)

var current_health := 0.0:
	set(value):
		print("New health" + str(value) + " " + str(get_parent()))
		current_health = clampf(value, 0, max_health)
		current_health_changed.emit(current_health)
		if is_zero_approx(current_health):
			print("%s health depleted" % get_parent())
			health_depleted.emit()


func _ready() -> void:
	# Since current health won't consider value from @export.
	current_health = max_health


func get_current_health_percentage() -> float:
	return current_health / max_health

func take_damage(damage: float) -> void:
	current_health -= damage
