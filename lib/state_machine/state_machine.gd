class_name StateMachine
extends Node

var _current_state: State


func _ready() -> void:
	_set_state_machine_status(false)


func _process(delta: float) -> void:
	_current_state.update(delta)

func _physics_process(delta: float) -> void:
	_current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	_current_state.handle_input(event)


func start(state: State) -> void:
	_change_state(state)
	_set_state_machine_status(true)


func _change_state(new_state: State) -> void:
	if _current_state != null:
		_current_state.exit()
	new_state.enter()
	_current_state = new_state
	_current_state.state_change_requested.connect(_change_state)

func _set_state_machine_status(active: bool):
	set_process(active)
	set_physics_process(active)
	set_process_unhandled_input(active)
