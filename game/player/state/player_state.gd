class_name PlayerState
extends State

var _player: Player


func _init(data: Dictionary) -> void:
	super(data)
	assert(data.has("player"))
	_player = data.player
