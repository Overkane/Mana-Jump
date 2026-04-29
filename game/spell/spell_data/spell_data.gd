class_name SpellData
extends Resource

# TODO. Delete if not needed.
enum Id {
	NONE = 0,
	MAGIC_MISSILE = 1,
}

enum Direction {
	NONE = 0,
	ENEMY = 1,
}

@export var name := "SpellName"
@export var id: Id
@export var damage: float
@export var spell: PackedScene
@export var direction: Direction
@export var speed: float
@export var mana_cost: float
@export var projectile_quantity: int
@export var homing := false
