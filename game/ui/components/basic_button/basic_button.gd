class_name BasicButton
extends Button

func _ready() -> void:
	@warning_ignore_start("return_value_discarded")
	pressed.connect(_on_pressed)
	focus_exited.connect(_on_focus_exited)
	mouse_entered.connect(_on_mouse_entered)
	@warning_ignore_restore("return_value_discarded")


func _on_pressed() -> void:
	AudioSystem.play_ui(Sounds.UI.UI_PRESS)

func _on_focus_exited() -> void:
	if Input.is_action_just_pressed(&"ui_up") or Input.is_action_just_pressed(&"ui_down"):
		AudioSystem.play_ui(Sounds.UI.UI_HOVER)

func _on_mouse_entered() -> void:
	if not has_focus():
		AudioSystem.play_ui(Sounds.UI.UI_HOVER)
