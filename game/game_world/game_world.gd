extends Node2D

@onready var player: Player = %Player
@onready var player_spawn_point: Marker2D = %PlayerSpawnPoint


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(InputSystem.get_action_name(GameInputs.ActionID.DEBUG_RESET)):
		player.global_position = player_spawn_point.global_position
