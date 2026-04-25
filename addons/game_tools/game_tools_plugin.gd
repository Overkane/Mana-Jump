@tool
extends EditorPlugin


const GameTools := preload("uid://br1ck2w5aexcl")

var _game_tools: Control


func _enable_plugin() -> void:
	# Add autoloads here.
	pass

func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	_game_tools = GameTools.instantiate()
	EditorInterface.get_editor_main_screen().add_child(_game_tools)

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	if _game_tools:
		_game_tools.queue_free()

func _has_main_screen():
	return true

func _make_visible(visible):
	if _game_tools:
		_game_tools.visible = visible

func _get_plugin_name():
	return "Game Tools"

func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
