class_name ActionRemapButton
extends Button
# BUG Can press with mouse on multiple ones hotkeys, should cancel it
# BUG Should cancel when during binding is cancel pressed or defautls
@export var _action_id: GameInputs.ActionID

var _action_name: String


func _ready() -> void:
	@warning_ignore_start("return_value_discarded")
	EventBus.ui_set_control_defaults.connect(_on_ui_set_control_defaults)
	@warning_ignore_restore("return_value_discarded")

	_action_name = InputSystem.get_action_name(_action_id)
	assert(InputMap.has_action(_action_name))
	set_process_input(false)
	_display_current_key()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_action(&"ui_accept") and not event.is_action(&"ui_cancel"):
		InputSystem.rebind_action(_action_id, event as InputEventKey)
		button_pressed = false

func _toggled(toggled_on: bool) -> void:
	set_process_input(toggled_on)
	if toggled_on:
		text = "<press a key>"
		self_modulate = Color.BLUE
		release_focus()
	else:
		_display_current_key()
		self_modulate = Color.WHITE
		grab_focus()


func _display_current_key() -> void:
	var events: Array[InputEvent] = InputMap.action_get_events(_action_name)
	# TODO Can bind only 1 key to action for now
	var first_event: String = events[0].as_text()
	text = first_event

# TODO what if during binding we exit the menu or will press during binding.
func _on_ui_set_control_defaults() -> void:
	_display_current_key()
