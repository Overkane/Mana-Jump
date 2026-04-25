class_name InputSystem
extends Node
# TODO allow second keybinds for joystick
# TODO game should see the joypad when plugged or keyboard when clicked

const CONFIG_FILE_NAME := "user://controls.json"

static var _keymap: Dictionary[int, InputAction]


static func add_action(action_id: int, action_name: String, input_event: InputEventKeyWrapper) -> void:
	assert(not InputMap.has_action(action_name))

	var input_action: InputAction = InputAction.new()
	input_action.action_id = action_id
	input_action.action_name = action_name
	input_action.default_input_events = [input_event]
	_keymap.set(action_id, input_action)

	InputMap.add_action(action_name)
	InputMap.action_add_event(action_name, input_event)

static func rebind_action(action_id: int, input_event: InputEventKey) -> void:
	assert(_keymap.has(action_id))

	var input_action: InputAction = _keymap.get(action_id)
	var input_event_key := InputEventKeyWrapper.new()
	input_event_key.physical_keycode = input_event.physical_keycode
	input_action.custom_input_events = [input_event_key]

	InputMap.action_erase_events(input_action.action_name)
	InputMap.action_add_event(input_action.action_name, input_event)

	save()

static func get_action_name(action_id: int) -> String:
	return _keymap.get(action_id).action_name

static func save() -> void:
	var input_action_list: Array[Dictionary]
	for action_id in _keymap:
		var input_action: InputAction = _keymap.get(action_id)
		input_action_list.append(input_action.serialize())

	var config_file := FileAccess.open(CONFIG_FILE_NAME, FileAccess.WRITE)
	var encoded_data := StringUtils.encode_data(input_action_list)
	config_file.store_string(encoded_data)

# TODO refactor
static func load_custom_keys() -> void:
	# Load always should happen after default keys are initialized, since we rebind only custom keys.
	assert(not _keymap.is_empty())

	var config_file := FileAccess.open(CONFIG_FILE_NAME, FileAccess.READ)
	if config_file == null:
		return

	var input_actions_data: Array[Dictionary] = StringUtils.decode_data(config_file.get_as_text())
	print(_keymap)
	print(input_actions_data)
	for input_action_data in input_actions_data:
		var input_action: InputAction = InputAction.deserialize(input_action_data)
		if input_action.custom_input_events.size() > 0:
			rebind_action(input_action.action_id, input_action.custom_input_events[0])
	print(_keymap)
	# 	# Don't replace keymaps dictionary, cuz if some actions were added/removed later,
	# # then keymap may have invalid actions (which were removed or won't have new ones).
	# # So take only actions current game version is actually have.
	# for action: StringName in data.keys():
	# 	if InputMap.has_action(action):
	# 		keymaps[action] = data.action
	# 		InputMap.action_erase_events(action)
	# 		InputMap.action_add_event(action, data.get(action))

static func set_defaults() -> void:
	for action_id in _keymap:
		var input_action: InputAction = _keymap.get(action_id)
		input_action.custom_input_events = []

		InputMap.action_erase_events(input_action.action_name)
		for input_event in input_action.default_input_events:
			InputMap.action_add_event(input_action.action_name, input_event)
	# TODO place save in proper place somewhere
	save()


# TODO use factory pattern?
# TODO some general purpose serializator with versioning and transition between versions?
class InputAction extends RefCounted:
	var action_id: int
	var action_name: String
	# TODO Perhaps should remove default inputs and store them outside of class.
	var default_input_events: Array[InputEvent]
	var custom_input_events: Array[InputEvent]

	static func deserialize(data: Dictionary) -> InputAction:
		var input_action := InputAction.new()
		input_action.action_id = data.action_id
		input_action.action_name = data.action_name

		for input_event: Dictionary in data.default_input_events:
			input_action.default_input_events.append(InputEventKeyWrapper.deserialize(input_event))

		for input_event: Dictionary in data.custom_input_events:
			input_action.custom_input_events.append(InputEventKeyWrapper.deserialize(input_event))

		return input_action

	func serialize() -> Dictionary:
		var serialized_default_input_events: Array[Dictionary] = []
		for input_event in default_input_events:
			serialized_default_input_events.append(input_event.serialize())

		var serialized_custom_input_events: Array[Dictionary] = []
		for input_event in custom_input_events:
			serialized_custom_input_events.append(input_event.serialize())
		# self get property list?
		return {
			"action_id": action_id,
			"action_name": action_name,
			"default_input_events": serialized_default_input_events,
			"custom_input_events": serialized_custom_input_events,
		}


class InputEventKeyWrapper extends InputEventKey:
	static func deserialize(data: Dictionary) -> InputEventKeyWrapper:
		var input_event_key := InputEventKeyWrapper.new()
		input_event_key.physical_keycode = data.physical_keycode
		return input_event_key

	func serialize() -> Dictionary:
		return {
			"physical_keycode": physical_keycode,
		}
