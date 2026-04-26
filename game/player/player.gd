class_name Player
extends CharacterBody2D

@onready var state_machine: StateMachine = %StateMachine


func _ready() -> void:
	var data := { "player": self }
	state_machine.start(PlayerStandingState.new(data))


func move(_velocity: Vector2) -> void:
	velocity = _velocity
	move_and_slide()
