class_name SettingCheckButton
extends HBoxContainer

@export var setting: GameSettings.SettingType

@onready var _check_button: CheckButton = %CheckButton


func _ready() -> void:
	@warning_ignore("return_value_discarded")
	_check_button.toggled.connect(_on_check_button_toggled)

	var setting_value: float = GameSettings.get_setting(setting).get_value()
	_check_button.set_pressed_no_signal(setting_value)


func set_text(text: String) -> void:
	_check_button.text = text


func _on_check_button_toggled(toggled_on: bool) -> void:
	GameSettings.get_setting(setting).set_value(toggled_on)
