class_name Game
extends Node

enum GameState {
	MAIN_MENU = 0,
	PLAYING = 1,
	PAUSED = 2,
}

var _current_game_state: GameState

@onready var _pause_menu: PauseMenu = %PauseMenu
@onready var _main_menu: MainMenu = $UI/MainMenu


func _enter_tree() -> void:
	_game_init()

func _ready() -> void:
	@warning_ignore("return_value_discarded")
	_main_menu.game_started.connect(_on_game_started)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(InputSystem.get_action_name(GameInputs.ActionID.PAUSE)) \
		and _current_game_state == GameState.PLAYING:
		_current_game_state = GameState.PAUSED
		# TODO LOW. Should be better way to handle menu transition.
		get_tree().paused = true
		_pause_menu.open()
		await _pause_menu.closed
		_current_game_state = GameState.PLAYING
		get_viewport().set_input_as_handled()


func _game_init() -> void:
	_current_game_state = GameState.MAIN_MENU
	GameSettings.init()
	GameInputs.init()


func _on_game_started() -> void:
	_current_game_state = GameState.PLAYING
