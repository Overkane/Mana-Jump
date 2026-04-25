class_name CameraController2D
extends Camera2D

# NOTE don't make min zoom smaller, because if camera area will be bigger than
# playable area, then camera clamping won't work correctly, since it can't be clamped
var _min_zoom := Vector2(0.75, 0.75)
var _max_zoom := Vector2(2.0, 2.0)
var _zoom_change := Vector2(0.1, 0.1)
var _is_panning := false
var _last_mouse_position: Vector2
var _camera_limits: Rect2i


func setup(camera_limits: Rect2i) -> void:
	_camera_limits = camera_limits

#func set_hud(hud: HUD) -> void:
	#_hud = hud


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"zoom_in"):
		zoom = _max_zoom.min(zoom + _zoom_change)
	elif event.is_action_pressed(&"zoom_out"):
		zoom = _min_zoom.max(zoom - _zoom_change)
	elif event.is_action_pressed(&"camera_panning"):
		_is_panning = true
		_last_mouse_position = get_global_mouse_position()
	elif event.is_action_released(&"camera_panning"):
		_is_panning = false
	elif event is InputEventMouseMotion:
		if _is_panning:
			var delta = _last_mouse_position - get_global_mouse_position()
			global_position += delta

	clamp_camera()


func clamp_camera() -> void:
	var viewport_size := get_viewport_rect().size
	var half_camera := viewport_size * 0.5 / zoom
	var min_x := _camera_limits.position.x + half_camera.x
	var max_x := _camera_limits.end.x - half_camera.x
	var min_y := _camera_limits.position.y + half_camera.y
	var max_y := _camera_limits.end.y - half_camera.y
	# NOTE for player to be able scroll all the way down and see all the game area without
	# overlapping it with HUD, we increase camera max y axis limit by the hud height.
	#var hud_height_adjustment := _hud.get_bottom_panel_height() / zoom.y

	global_position.x = clampi(global_position.x, min_x, max_x)
	#global_position.y = clampi(global_position.y, min_y, max_y + hud_height_adjustment)
	global_position.y = clampi(global_position.y, min_y, max_y)
