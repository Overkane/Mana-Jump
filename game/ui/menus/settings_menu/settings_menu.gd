class_name SettingsMenu
extends Control

@onready var _close_button: Button = %CloseButton
@onready var _default_controls_button: Button = %DefaultControlsButton
@onready var _options_general_tab: Control = %GeneralTab
@onready var _options_controls_tab: Control = %ControlsTab
@onready var _action_move_down_label: Label = %ActionMoveDownLabel
@onready var _action_move_up_label: Label = %ActionMoveUpLabel
@onready var _action_move_right: Label = %ActionMoveRight
@onready var _action_move_left_label: Label = %ActionMoveLeftLabel
@onready var _master_audio_slider: SettingSlider = %MasterAudioSlider
@onready var _music_audio_slider: SettingSlider = %MusicAudioSlider
@onready var _sfx_audio_slider: SettingSlider = %SFXAudioSlider
@onready var _settings_check_button: SettingCheckButton = %VSyncSettingsCheckButton
@onready var _window_mode_settings_check_button: SettingCheckButton = %WindowModeSettingsCheckButton
@onready var _mouse_mode_settings_check_button: SettingCheckButton = %MouseModeSettingsCheckButton


func _ready() -> void:
	@warning_ignore_start("return_value_discarded")
	EventBus.ui_settings_menu_requested.connect(_open)
	_close_button.pressed.connect(_on_close_button_pressed)
	_default_controls_button.pressed.connect(_on_default_controls_button_pressed)
	@warning_ignore_restore("return_value_discarded")

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready

		# TODO LOW. Check when godot will add feature to set context for a label/button, to not do this stuff.
		_master_audio_slider.set_text(tr("Master", "UI"))
		_music_audio_slider.set_text(tr("Music", "UI"))
		_sfx_audio_slider.set_text(tr("Sound", "UI"))
		_settings_check_button.set_text("VSync")
		_window_mode_settings_check_button.set_text(tr("Fullscreen", "UI"))
		_mouse_mode_settings_check_button.set_text(tr("Mouse Lock", "UI"))

		_options_general_tab.name = tr("General", "UI")
		_options_controls_tab.name = tr("Controls", "UI")

		_close_button.text = tr("Close", "UI")

		_action_move_down_label.text = tr("Move down", "UI")
		_action_move_up_label.text = tr("Move up", "UI")
		_action_move_right.text = tr("Move right", "UI")
		_action_move_left_label.text = tr("Move left", "UI")
		_default_controls_button.text = tr("Defaults", "UI")


func _open() -> void:
	show()
	_close_button.grab_focus()

func _on_default_controls_button_pressed() -> void:
	InputSystem.set_defaults()
	EventBus.ui_set_control_defaults.emit()

func _on_close_button_pressed() -> void:
	hide()
	EventBus.ui_settings_menu_closed.emit()
