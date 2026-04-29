class_name Spell
extends Node

static func cast(spell_data: SpellData, position: Vector2) -> void:
	var spell := spell_data.spell.instantiate() as Spell
	spell.setup(spell_data)
	spell.global_position = position
	spell.get_tree().root.add_child(spell)


func _setup(spell_data: SpellData):
	pass
