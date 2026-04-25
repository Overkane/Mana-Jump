class_name PauseMenu
extends Control

signal closed

@onready var _continue_button: BasicButton = %ContinueButton
@onready var _settings_button: BasicButton = %SettingsButton
@onready var _credits_button: BasicButton = %CreditsButton
@onready var _quit_button: BasicButton = %QuitButton


func _ready() -> void:
	@warning_ignore_start("return_value_discarded")
	_continue_button.pressed.connect(_on_continue_button_pressed)
	_settings_button.pressed.connect(_on_settings_button_pressed)
	_credits_button.pressed.connect(_on_credits_button_pressed)
	_quit_button.pressed.connect(_on_quit_button_pressed)
	@warning_ignore_restore("return_value_discarded")

	if OS.has_feature("web"):
		_quit_button.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(InputSystem.get_action_name(GameInputs.ActionID.PAUSE)) and visible:
		get_tree().paused = false
		hide()
		closed.emit()
		get_viewport().set_input_as_handled()

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready
		_continue_button.text = tr("Continue", "UI")
		_settings_button.text = tr("Settings", "UI")
		_credits_button.text = tr("Credits", "UI")
		_quit_button.text = tr("Quit", "UI")


func open() -> void:
	show()
	_continue_button.grab_focus()


func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	hide()
	closed.emit()

func _on_settings_button_pressed() -> void:
	hide()
	EventBus.ui_settings_menu_requested.emit()
	await EventBus.ui_settings_menu_closed
	_settings_button.grab_focus()
	show()

func _on_credits_button_pressed() -> void:
	hide()
	EventBus.ui_credits_menu_requested.emit()
	await EventBus.ui_credits_menu_closed
	_credits_button.grab_focus()
	show()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
