class_name Platforms
extends CharacterBody2D

const JUMP_VELOCITY = 600
const GRAVITY = -900

#
#func _ready() -> void:
	#set_physics_process(false)
	#EventBus.platform_jump.connect(jump)
	#EventBus.platform_jump_stop.connect(jump_stop)
#
#
#func jump() -> void:
	#velocity.y = JUMP_VELOCITY
	#set_physics_process(true)
#
#func jump_stop() -> void:
	#set_physics_process(false)
#
#func _physics_process(delta: float) -> void:
	#print(velocity)
	##if velocity.y > 0:
	#velocity.y += GRAVITY * delta
		##velocity.y = max(velocity.y, 0)
	#move_and_slide()
