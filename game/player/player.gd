class_name Player
extends CharacterBody2D

const HORIZONTAL_SPEED = 125
const JUMP_VELOCITY = 400
const GRAVITY = 900

const _COYOTE_FRAMES = 5

static var coyote_time: float = float(_COYOTE_FRAMES) / Engine.physics_ticks_per_second

@onready var _state_machine: StateMachine = %StateMachine
@onready var _health: ComponentHealth = %Health
@onready var _hurtbox_2d: ComponentHurtbox2D = %Hurtbox2D


func _ready() -> void:
	_hurtbox_2d.got_hit.connect(_on_hit)

	var data := {"player": self }
	_state_machine.start(PlayerStandingState.new(data))


func move(_velocity: Vector2) -> void:
	velocity = _velocity + get_platform_velocity()
	move_and_slide()


func _on_hit(hitbox: ComponentHitbox2D) -> void:
	_health.take_damage(hitbox.damage)
