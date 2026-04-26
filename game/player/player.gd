class_name Player
extends CharacterBody2D

const HORIZONTAL_SPEED = 125
const JUMP_VELOCITY = 400
const GRAVITY = 900

@onready var state_machine: StateMachine = %StateMachine


func _ready() -> void:
	var data := {"player": self }
	state_machine.start(PlayerStandingState.new(data))


func move(_velocity: Vector2) -> void:
	velocity = _velocity + get_platform_velocity()
	move_and_slide()
