class_name PlayerWalkingState
extends PlayerState

var _current_coyote_time := 0.0
var _was_coyote_time_active := false


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
		_player.move(direction * Player.HORIZONTAL_SPEED)
		if not _player.is_on_floor():
			if _current_coyote_time > 0:
				_current_coyote_time -= delta
			# TODO perhaps should do that in another state
			if not _was_coyote_time_active:
				_was_coyote_time_active = true
				_current_coyote_time = Player.coyote_time
			elif _current_coyote_time < 0 or is_zero_approx(_current_coyote_time):
				state_change_requested.emit(PlayerFallingState.new(_data))
		else:
			_was_coyote_time_active = false
	else:
		state_change_requested.emit(PlayerStandingState.new(_data))
