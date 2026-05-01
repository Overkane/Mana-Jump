class_name Player
extends CharacterBody2D

const HORIZONTAL_SPEED = 125
const JUMP_VELOCITY = 400
const GRAVITY = 900

const _COYOTE_FRAMES = 5
const _MANA_GAIN_PER_JUMP = 1.0

static var coyote_time: float = float(_COYOTE_FRAMES) / Engine.physics_ticks_per_second

var _spells: Dictionary[SpellData, float]

@onready var _state_machine: StateMachine = %StateMachine
@onready var _health: ComponentHealth = %Health
@onready var _hurtbox_2d: ComponentHurtbox2D = %Hurtbox2D
@onready var _spell_cast_point_2d: Marker2D = %SpellCastPoint2D


func _ready() -> void:
	_hurtbox_2d.got_hit.connect(_on_hit)

	var data := {"player": self }
	_state_machine.start(PlayerStandingState.new(data))

	# TODO temporary solution
	_spells[Spells.MAGIC_MISSILE] = 0.0


func move(_velocity: Vector2) -> void:
	velocity = _velocity + get_platform_velocity()
	move_and_slide()

func get_mana() -> void:
	for spell_data: SpellData in _spells:
		_spells[spell_data] += _MANA_GAIN_PER_JUMP
		if _spells[spell_data] > spell_data.mana_cost or is_equal_approx(_spells[spell_data], spell_data.mana_cost):
			# TODO. Can have mana for several casts.
			_spells[spell_data] -= spell_data.mana_cost
			Spell.cast(self, _spell_cast_point_2d.global_position, spell_data)


func _on_hit(hitbox: ComponentHitbox2D) -> void:
	_health.take_damage(hitbox.damage)
