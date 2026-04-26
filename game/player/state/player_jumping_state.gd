class_name PlayerJumpingState
extends PlayerState

var _velocity: Vector2


func enter() -> void:
	_velocity.y = - Player.JUMP_VELOCITY
	pass # Jumping animation

func physics_update(delta: float) -> void:
	_velocity.y += Player.GRAVITY * delta

	var horizontal_direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed(InputSystem.get_action_name(GameInputs.ActionID.MOVE_RIGHT)):
		horizontal_direction = Vector2.RIGHT
	elif Input.is_action_pressed(InputSystem.get_action_name(GameInputs.ActionID.MOVE_LEFT)):
		horizontal_direction = Vector2.LEFT

	if horizontal_direction != Vector2.ZERO:
		_velocity.x = horizontal_direction.x * Player.HORIZONTAL_SPEED

	_player.move(_velocity)

	if _player.is_on_floor():
		state_change_requested.emit(PlayerStandingState.new(_data))
