class_name SettingSlider
extends HBoxContainer

@export var setting: GameSettings.SettingType

@onready var _slider_label: Label = %SliderLabel
@onready var _slider: HSlider = %HSlider


func _ready() -> void:
	@warning_ignore("return_value_discarded")
	_slider.value_changed.connect(_on_slider_value_changed)

	var setting_value: float = GameSettings.get_setting(setting).get_value()
	_slider.set_value_no_signal(setting_value)


func set_text(text: String) -> void:
	_slider_label.text = text


func _on_slider_value_changed(value: float) -> void:
	GameSettings.get_setting(setting).set_value(value)
