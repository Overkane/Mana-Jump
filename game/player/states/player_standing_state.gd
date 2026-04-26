class_name PlayerStandingState
extends State

var _player: Player


func _init(data: Dictionary) -> void:
	super(data)
	assert(data.has("player"))
	_player = data.player


func enter() -> void:
	pass # Standing animation

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputSystem.get_action_name(GameInputs.ActionID.JUMP)):
		state_change_requested.emit(PlayerJumpingState.new(_data))

func physics_update(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed(InputSystem.get_action_name(GameInputs.ActionID.MOVE_RIGHT)):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed(InputSystem.get_action_name(GameInputs.ActionID.MOVE_LEFT)):
		direction = Vector2.LEFT

	if direction != Vector2.ZERO:
		state_change_requested.emit(PlayerWalkingState.new(_data))

	if not _player.is_on_floor():
		state_change_requested.emit(PlayerFallingState.new(_data))
