class_name XpOrbData
extends Resource

# TODO. Delete if not needed.
enum Id {
	NONE = 0,
	SMALL_ORB = 1,
	MEDIUM_ORB = 2,
	BIG_ORB = 3,
}

@export var id: Id
@export var orb_sprite: Texture2D
@export var xp_amount: int
