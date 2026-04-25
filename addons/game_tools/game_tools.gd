@tool
class_name GameTools
extends Control

@export_file("*.pot") var _pot_file_path: String
@export_dir() var _po_files_folder_path: String

@onready var perform_translation_gettext: Button = %PerformTranslationGettext


func _ready() -> void:
	perform_translation_gettext.pressed.connect(_on_perform_translation_gettext_pressed)


func _on_perform_translation_gettext_pressed() -> void:
	# Generate POT file.
	var localization = EditorInterface.get_base_control().find_child("*Localization*", true, false)
	var file_dialog: EditorFileDialog = localization.get_child(5)
	file_dialog.file_selected.emit(_pot_file_path)

	# Update .po files from POT file.
	for file in DirAccess.get_files_at(_po_files_folder_path):
		if file.get_extension() == "po":
			var output: Array
			OS.execute(
				"msgmerge",
				[
					"--update",
					"--backup=none",
					ProjectSettings.globalize_path(_po_files_folder_path).path_join(file),
					ProjectSettings.globalize_path(_pot_file_path)
				],
				output,
				true
			)
			print(ProjectSettings.globalize_path(_po_files_folder_path).path_join(file))
			print(ProjectSettings.globalize_path(_pot_file_path))
			print(output)

	# TODO Translate untranslated strings from all .po files.
