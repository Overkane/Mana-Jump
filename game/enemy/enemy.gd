class_name Enemy
extends Node2D

@onready var _hurtbox_2d: ComponentHurtbox2D = %Hurtbox2D
@onready var _health: ComponentHealth = %Health


func _ready() -> void:
	_hurtbox_2d.got_hit.connect(_on_hit)
	_health.health_depleted.connect(_on_health_depleted)

	add_to_group(Groups.ENEMIES)


func _on_health_depleted() -> void:
	queue_free() # TODO perhaps need free() cuz spells aimed at that enemy can keep it lilve.

func _on_hit(hitbox: ComponentHitbox2D) -> void:
	_health.take_damage(hitbox.damage)
