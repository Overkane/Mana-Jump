@abstract
class_name State
extends RefCounted

signal state_change_requested(state: State)


var _data: Dictionary


func _init(data: Dictionary) -> void:
	_data = data


func enter() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	pass

func exit() -> void:
	pass
