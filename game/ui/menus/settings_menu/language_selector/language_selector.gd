class_name LanguageSelector
extends MarginContainer
# TODO LOW.
# 1. Recheck if something is missing translation or translation is wrong.
# 2. Check if some UI breaks on different languages (bigger text etc).


# TODO LOW. get_language_name returns any language in English.
# Should be solved in https://github.com/godotengine/godot/pull/78006
# Cuz of that map languages manually for now.
const translated_language_map: Dictionary[String, String] = {
	"Russian": "Русский",
	"English": "English",
	"German": "Deutsch",
	"es_ES": "Español (España)",
	"French": "Français",
	"Italian": "Italiano",
	"Polish": "Polski",
	"Japanese": "日本語",
	"Korean": "한국어",
	"zh_CN": "简体中文",
	"pt_BR": "Português (Brasil)",
}

@onready var _language_list: OptionButton = %LanguageList
@onready var _label: Label = %Label


func _ready() -> void:
	@warning_ignore("return_value_discarded")
	_language_list.item_selected.connect(_on_language_selected)

	var id := 0
	for loaded_locale in TranslationServer.get_loaded_locales():
		var language_name := TranslationServer.get_language_name(loaded_locale)
		var translated_language_name: String = translated_language_map.get(language_name)
		_language_list.add_item(translated_language_name, id)
		_language_list.set_item_metadata(id, loaded_locale)

		if loaded_locale == TranslationServer.get_locale():
			_language_list.select(id)

		id += 1

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready

		_label.text = tr("Language", "UI")


func _on_language_selected(index: int) -> void:
	var selected_locate := _language_list.get_item_metadata(index) as String
	GameSettings.get_setting(GameSettings.SettingType.LOCALE).set_value(selected_locate)
