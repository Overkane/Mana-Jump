class_name CreditsMenu
extends Control
# TODO LOW. Make version with autoscroll, instead of scrolling. But useful only for a long credits.
# TODO Add a panel behind or just black text.
# TODO add so could add styling to text directly with bb codes, instead of editing rich text label
# TODO perhaps remove button or make spacing better.
# TODO try push methods, without manually adding .

@export var credits_file: JSON

@onready var credits_text: RichTextLabel = %CreditsText
@onready var close_button: Button = %CloseButton


func _ready() -> void:
	@warning_ignore_start("return_value_discarded")
	EventBus.ui_credits_menu_requested.connect(_open)
	credits_text.meta_clicked.connect(_on_credits_text_meta_clicked)
	close_button.pressed.connect(_close_button_pressed)
	@warning_ignore_restore("return_value_discarded")

	var game_title: String = ProjectSettings.get_setting("application/config/name")
	credits_text.text = credits_text.text.replace("[GameTitle]", game_title)

	for credits_element: Dictionary in credits_file.data:
		var credits_entries: Array = credits_element.entries
		if credits_entries.is_empty():
			continue

		var credits_element_type: String = credits_element.type
		var total_entry_text: String = credits_element_type.trim_prefix("[").trim_suffix("]") + "\n"

		for credits_type_entry: Dictionary in credits_element.entries:
			var entry_text := "%s\n%s\n%s\n" % [
				"[hint=%s][url=%s]%s[/url][/hint]" % [credits_type_entry.source, credits_type_entry.source, credits_type_entry.name],
				credits_type_entry.author,
				credits_type_entry.license
			]
			total_entry_text += entry_text

		credits_text.text = credits_text.text.replace(credits_element.type, total_entry_text)

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready

		close_button.text = tr("Close", "UI")


func _open() -> void:
	show()
	close_button.grab_focus()

func _on_credits_text_meta_clicked(meta: String) -> void:
	OS.shell_open(meta)

func _close_button_pressed() -> void:
	hide()
	EventBus.ui_credits_menu_closed.emit()
