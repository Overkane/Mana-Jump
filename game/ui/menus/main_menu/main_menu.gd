class_name MainMenu
extends Control

signal game_started

@onready var _play_button: Button = %PlayButton
@onready var _settings_button: Button = %SettingsButton
@onready var _credits_button: Button = %CreditsButton
@onready var _quit_button: Button = %QuitButton
@onready var _game_title_label: Label = %GameTitleLabel
@onready var _game_version_label: Label = %GameVersionLabel


func _ready() -> void:
	@warning_ignore_start("return_value_discarded")
	_play_button.pressed.connect(_on_play_button_pressed)
	_settings_button.pressed.connect(_on_settings_button_pressed)
	_credits_button.pressed.connect(_on_credits_button_pressed)
	_quit_button.pressed.connect(_on_quit_button_pressed)
	@warning_ignore_restore("return_value_discarded")

	AudioSystem.play_music(Music.MAIN_MENU)

	_game_title_label.text = ProjectSettings.get_setting("application/config/name")

	var game_version: String = ProjectSettings.get_setting("application/config/version")
	if not game_version.is_empty():
		_game_version_label.text = game_version
	else:
		_game_version_label.hide()

	_play_button.grab_focus.call_deferred()

	if OS.has_feature("web"):
		_quit_button.hide()

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready
		_play_button.text = tr("Play", "UI")
		_settings_button.text = tr("Settings", "UI")
		_credits_button.text = tr("Credits", "UI")
		_quit_button.text = tr("Quit", "UI")


func _on_play_button_pressed() -> void:
	hide()
	game_started.emit()

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
