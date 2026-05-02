class_name EnemyData
extends Resource

# TODO. Delete if not needed.
enum Id {
	NONE = 0,
	BAT = 1,
}

@export var name := "EnemyName"
@export var id: Id
@export var enemy: PackedScene
@export var health: float
@export var damage: float
@export var speed: float
@export var xp: int
