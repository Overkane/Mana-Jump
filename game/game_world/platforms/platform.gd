class_name Platform
extends AnimatableBody2D

const _SPEED := 20.0

@onready var _visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D


func _ready() -> void:
	_visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)

func _physics_process(delta: float) -> void:
	pass
	# TODO. Should platforms move?
	#global_position.y += _SPEED * delta


func _on_screen_exited() -> void:
	queue_free()
