extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	var battler0 = get_child(0)
	var battler1 = get_child(1)
	print('0', battler0.stats.speed)
	print('1', battler1.stats.speed)
	if battler1.stats.speed > battler0.stats.speed:
		move_child(battler1, 0)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
