extends Node2D

@onready var _player: Player = %Player
@onready var _player_spawn_point: Marker2D = %PlayerSpawnPoint
@onready var _defeat_area: Area2D = %DefeatArea
@onready var _enemy_spawn_position: Marker2D = %EnemySpawnPosition


func _ready() -> void:
	_player.died.connect(_game_over)
	_defeat_area.body_entered.connect(_on_defeat_area_body_entered)

	# TODO. Temporary
	get_tree().create_timer(1).timeout.connect(func() -> void:
		Enemy.create(self, _enemy_spawn_position.global_position, Enemies.BAT)
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(InputSystem.get_action_name(GameInputs.ActionID.DEBUG_RESET)):
		_player.global_position = _player_spawn_point.global_position
	elif event.is_action_pressed(InputSystem.get_action_name(GameInputs.ActionID.DEBUG_ENEMY_SPAWN)):
		Enemy.create(self, _enemy_spawn_position.global_position, Enemies.BAT)


func _game_over() -> void:
	print("You lost.")

func _on_defeat_area_body_entered(player: Player) -> void:
	_game_over()
