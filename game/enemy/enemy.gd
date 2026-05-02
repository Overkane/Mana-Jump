class_name Enemy
extends Node2D

@onready var _hurtbox_2d: ComponentHurtbox2D = %Hurtbox2D
@onready var _health_component: ComponentHealth = %Health

var _health: float
var _damage: float
var _speed: float
var _xp: int


static func create(spawner: Node2D, spawn_position: Vector2, enemy_data: EnemyData) -> void:
	var enemy := enemy_data.enemy.instantiate() as Enemy
	enemy.setup(enemy_data)
	enemy.global_position = spawn_position
	spawner.get_tree().root.add_child(enemy)


func _ready() -> void:
	_hurtbox_2d.got_hit.connect(_on_hit)
	_health_component.health_depleted.connect(_on_health_depleted)

	add_to_group(Groups.ENEMIES)
	_health_component.set_health(_health)
	# TODO Set speed and behaviour in the specific enemy


func setup(enemy_data: EnemyData) -> void:
	_health = enemy_data.health
	_damage = enemy_data.damage
	_speed = enemy_data.speed
	_xp = enemy_data.xp


func _on_health_depleted() -> void:
	XpOrb.spawn_xp_orbs(self, _xp)
	queue_free() # TODO perhaps need free() cuz spells aimed at that enemy can keep it lilve.

func _on_hit(hitbox: ComponentHitbox2D) -> void:
	_health_component.take_damage(hitbox.damage)
