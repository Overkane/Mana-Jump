class_name MagicMissile
extends Spell

var _target: Node2D
var _last_direction: Vector2

@onready var _hitbox_2d: ComponentHitbox2D = %Hitbox2D


func _ready() -> void:
	_hitbox_2d.hit.connect(_on_hit)

	_hitbox_2d.damage = _damage

	_target = get_tree().get_first_node_in_group(Groups.ENEMIES)
	if _target == null:
		_last_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()

func _physics_process(delta: float) -> void:
	if _homing:
		if _target == null: # Enemy can die from other stuff.
			_target = get_tree().get_first_node_in_group(Groups.ENEMIES)

		if _target == null: # No enemies at all:
			global_position += _last_direction * _speed * delta
		else:
			global_position = global_position.move_toward(_target.global_position, _speed * delta)
			_last_direction = global_position.direction_to(_target.global_position)
	#else:
		#global_position = _direction * _speed * delta


func _on_hit() -> void:
	queue_free()
