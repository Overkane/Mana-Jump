extends Node

const _BUFFER_FRAMES := 3

var _registered_events: Array[String]
var _buffer_timestamps: Dictionary[String, float]

var _buffer_time_msec: float = 1000 * float(_BUFFER_FRAMES) / Engine.physics_ticks_per_second


func _unhandled_key_input(event: InputEvent) -> void:
	for action in _registered_events:
		if event.is_action_pressed(action):
			_buffer_timestamps[action] = Time.get_ticks_msec()


func is_input_in_buffer(action: String) -> bool:
	var input_in_buffer := false
	if _buffer_timestamps.has(action):
		var time_difference := Time.get_ticks_msec() - _buffer_timestamps[action]
		if time_difference <= _buffer_time_msec:
			_buffer_timestamps[action] = 0.0
			input_in_buffer = true

	return input_in_buffer

func register_event_for_buffering(event: String) -> void:
	_registered_events.append(event)
