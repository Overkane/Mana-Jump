class_name GameInputs
extends Node

enum ActionID {
	MOVE_UP = 0,
	MOVE_DOWN = 1,
	MOVE_LEFT = 2,
	MOVE_RIGHT = 3,
	PAUSE = 100,
}


static func init() -> void:
	_init_default_input_actions()
	InputSystem.load_custom_keys()


static func _init_default_input_actions() -> void:
	var input_event_key := InputSystem.InputEventKeyWrapper.new()
	input_event_key.physical_keycode = KEY_W
	InputSystem.add_action(ActionID.MOVE_UP, "move_up", input_event_key)

	# CHECK will be previous pointer not discarded for sure? Or not until function is finished?
	input_event_key = InputSystem.InputEventKeyWrapper.new()
	input_event_key.physical_keycode = KEY_S
	InputSystem.add_action(ActionID.MOVE_DOWN, "move_down", input_event_key)

	input_event_key = InputSystem.InputEventKeyWrapper.new()
	input_event_key.physical_keycode = KEY_D
	InputSystem.add_action(ActionID.MOVE_RIGHT, "move_right", input_event_key)

	input_event_key = InputSystem.InputEventKeyWrapper.new()
	input_event_key.physical_keycode = KEY_A
	InputSystem.add_action(ActionID.MOVE_LEFT, "move_left", input_event_key)

	input_event_key = InputSystem.InputEventKeyWrapper.new()
	input_event_key.physical_keycode = KEY_ESCAPE if OS.has_feature("pc") else KEY_P
	InputSystem.add_action(ActionID.PAUSE, "pause", input_event_key)
