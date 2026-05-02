class_name GameInputs
extends Node

enum ActionID {
	JUMP = 0,
	MOVE_DOWN = 1,
	MOVE_LEFT = 2,
	MOVE_RIGHT = 3,
	PAUSE = 100,
	DEBUG_RESET = 101,
	DEBUG_ENEMY_SPAWN = 102,
}


static func init() -> void:
	_init_default_input_actions()
	InputSystem.load_custom_keys()


static func _init_default_input_actions() -> void:
	var input_event_key := InputSystem.InputEventKeyWrapper.new()
	input_event_key.physical_keycode = KEY_W
	InputSystem.add_action(ActionID.JUMP, "move_up", input_event_key)
	InputBuffering.register_event_for_buffering("move_up")

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

	input_event_key = InputSystem.InputEventKeyWrapper.new()
	input_event_key.physical_keycode = KEY_R
	InputSystem.add_action(ActionID.DEBUG_RESET, "debug_reset", input_event_key)

	input_event_key = InputSystem.InputEventKeyWrapper.new()
	input_event_key.physical_keycode = KEY_T
	InputSystem.add_action(ActionID.DEBUG_ENEMY_SPAWN, "debug_enemy_spawn", input_event_key)
