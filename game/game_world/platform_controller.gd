class_name PlatformController
extends Node

const _BASE_PLATFORM_SPAWN_INTERVAL = 1.75
const _PLATFORM_SCENE = preload("uid://ckjlnqxmt81k3")

@onready var _platform_spawn_timer: Timer = %PlatformSpawnTimer
@onready var _platform_spawn_timer2: Timer = %PlatformSpawnTimer2
@onready var _platform_spawn_point: PathFollow2D = %PlatformSpawnPoint
@onready var _platforms: CharacterBody2D = %Platforms


func _ready() -> void:
	_platform_spawn_timer.timeout.connect(_on_spawn_timer_timeout.bind(_platform_spawn_timer))
	_platform_spawn_timer2.timeout.connect(_on_spawn_timer_timeout.bind(_platform_spawn_timer2))
	_platform_spawn_timer.start(_get_platform_spawn_interval())
	_platform_spawn_timer2.start(_get_platform_spawn_interval())


func _get_platform_spawn_interval() -> float:
	return _BASE_PLATFORM_SPAWN_INTERVAL + randf_range(-0.25, 0.25)

func _create_platform() -> void:
	var new_platform: Platform = _PLATFORM_SCENE.instantiate()
	_platform_spawn_point.progress_ratio = randf()
	new_platform.global_position = _platform_spawn_point.global_position
	_platforms.add_child(new_platform)


func _on_spawn_timer_timeout(timer: Timer) -> void:
	_create_platform()
	timer.start(_get_platform_spawn_interval())
