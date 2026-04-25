class_name GameSettings
extends RefCounted

enum SettingType {
	# Audio, 0-9 are reserved
	AUDIO_MASTER_VOLUME = 0,
	AUDIO_MUSIC_VOLUME = 1,
	AUDIO_SFX_VOLUME = 2,
	AUDIO_UI_VOLUME = 3,
	# Locale
	LOCALE = 10,
	# Graphics, 20-100 are reserved
	IS_VSYNC_ON = 20,
	IS_FULLSCREEN_ON = 21,
	# Misc 101-200 are reserved
	IS_MOUSE_LOCKED = 101,
}

const CONFIG_FILE_NAME := "user://settings.json"
const AUDIO_SETTINGS_MAP: Dictionary[SettingType, AudioSystem.AudioBus] = {
	SettingType.AUDIO_MASTER_VOLUME: AudioSystem.AudioBus.MASTER,
	SettingType.AUDIO_MUSIC_VOLUME: AudioSystem.AudioBus.MUSIC,
	SettingType.AUDIO_SFX_VOLUME: AudioSystem.AudioBus.SFX,
	SettingType.AUDIO_UI_VOLUME: AudioSystem.AudioBus.UI,
}

static var settings: Dictionary[SettingType, GameSetting] = {}


static func init() -> void:
	_init_default_settings()
	_load()

static func get_setting(setting_type: SettingType) -> GameSetting:
	assert(settings.has(setting_type))
	return settings.get(setting_type)

static func save() -> void:
	var settings_data: Array[Dictionary] = []
	for setting_type in settings:
		var setting: GameSetting = settings[setting_type]
		var setting_dict: Dictionary = {
			"setting_type": setting_type,
			"value": setting.get_value(),
		}
		settings_data.append(setting_dict)

	var config_file := FileAccess.open(CONFIG_FILE_NAME, FileAccess.WRITE)
	var encoded_data := StringUtils.encode_data(settings_data)
	config_file.store_string(encoded_data)


static func _load() -> void:
	var config_file := FileAccess.open(CONFIG_FILE_NAME, FileAccess.READ)
	if config_file == null:
		return

	var settings_data: Array[Dictionary] = StringUtils.decode_data(config_file.get_as_text())
	for setting_dict in settings_data:
		var setting_type: SettingType = setting_dict["setting_type"]
		if not settings.has(setting_type):
			continue

		var value: Variant = setting_dict["value"]
		if settings.has(setting_type):
			settings.get(setting_type).set_value(value, false)

static func _init_default_settings() -> void:
	@warning_ignore_start("return_value_discarded")
	# Audio
	GameSetting.new(
		SettingType.AUDIO_MASTER_VOLUME,
		0.75,
		func(value: float) -> float:
			value = clamp(value, 0.0, 1.0)
			AudioServer.set_bus_volume_db(AUDIO_SETTINGS_MAP[SettingType.AUDIO_MASTER_VOLUME], linear_to_db(value))
			return value
	)
	GameSetting.new(
		SettingType.AUDIO_MUSIC_VOLUME,
		1.0,
		func(value: float) -> float:
			value = clamp(value, 0.0, 1.0)
			AudioServer.set_bus_volume_db(AUDIO_SETTINGS_MAP[SettingType.AUDIO_MUSIC_VOLUME], linear_to_db(value))
			return value
	)
	GameSetting.new(
		SettingType.AUDIO_SFX_VOLUME,
		1.0,
		func(value: float) -> float:
			value = clamp(value, 0.0, 1.0)
			AudioServer.set_bus_volume_db(AUDIO_SETTINGS_MAP[SettingType.AUDIO_SFX_VOLUME], linear_to_db(value))
			AudioServer.set_bus_volume_db(AUDIO_SETTINGS_MAP[SettingType.AUDIO_UI_VOLUME], linear_to_db(value))
			return value
	)
	# Locale
	GameSetting.new(
		SettingType.LOCALE,
		OS.get_locale(),
		func(value: String) -> String:
			TranslationServer.set_locale(value)
			return value
	)
	# Graphics
	GameSetting.new(
		SettingType.IS_VSYNC_ON,
		DisplayServer.VSyncMode.VSYNC_DISABLED,
		func(is_vsync_on: bool) -> bool:
			var vsync_mode := DisplayServer.VSyncMode.VSYNC_ENABLED if is_vsync_on else DisplayServer.VSyncMode.VSYNC_DISABLED
			DisplayServer.window_set_vsync_mode(vsync_mode, DisplayServer.MAIN_WINDOW_ID)
			return is_vsync_on
	)
	GameSetting.new(
		SettingType.IS_FULLSCREEN_ON,
		Window.Mode.MODE_EXCLUSIVE_FULLSCREEN,
		func(is_fullscreen_on: bool) -> bool:
			var window_mode := DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if is_fullscreen_on \
				else DisplayServer.WindowMode.WINDOW_MODE_WINDOWED
			DisplayServer.window_set_mode(window_mode, DisplayServer.MAIN_WINDOW_ID)
			return is_fullscreen_on
	)
	# Misc
	GameSetting.new(
		SettingType.IS_MOUSE_LOCKED,
		DisplayServer.MouseMode.MOUSE_MODE_VISIBLE,
		func(is_mouse_locked: bool) -> bool:
			var mouse_mode := DisplayServer.MouseMode.MOUSE_MODE_CONFINED if is_mouse_locked \
				else DisplayServer.MouseMode.MOUSE_MODE_VISIBLE
			DisplayServer.mouse_set_mode(mouse_mode)
			return is_mouse_locked
	)
	@warning_ignore_restore("return_value_discarded")


class GameSetting extends RefCounted:
	var _setting_type: SettingType
	var _value: Variant # Can be only primitive types
	var _set_function: Callable


	func _init(setting_type: SettingType, default_value: Variant, set_function: Callable) -> void:
		GameSettings.settings[setting_type] = self
		_setting_type = setting_type
		_set_function = set_function
		set_value(default_value, false)


	func set_value(value: Variant, save := true) -> void:
		_value = _set_function.call(value)
		if save:
			GameSettings.save()

	func get_value() -> Variant:
		return _value
