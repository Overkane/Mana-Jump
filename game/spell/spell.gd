class_name Spell
extends Node2D

var _damage: float
var _direction: SpellData.Direction
var _speed: float
@export var projectile_quantity: int
var _homing := false


static func cast(caster: Node2D, cast_position: Vector2, spell_data: SpellData) -> void:
	for i in spell_data.projectile_quantity:
		var spell := spell_data.spell.instantiate() as Spell
		spell.setup(spell_data)
		spell.global_position = cast_position
		caster.get_tree().root.add_child(spell)


func setup(spell_data: SpellData) -> void:
	_damage = spell_data.damage
	_direction = spell_data.direction
	_speed = spell_data.speed
	_homing = spell_data.homing
