class_name ComponentHitbox2D
extends Area2D

signal hit

@export var damage := 5


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)


func _on_area_entered(hurtbox: ComponentHurtbox2D) -> void:
	hit.emit()
	hurtbox.got_hit.emit(self)

func _on_body_entered(_body: Node2D) -> void:
	hit.emit()
