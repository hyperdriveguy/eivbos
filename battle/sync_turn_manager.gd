extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	print(get_child(0).stats.speed)
	print(get_child(1).stats.speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
