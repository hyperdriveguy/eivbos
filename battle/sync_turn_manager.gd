extends Node

var cur_battlers_moved: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_sort_battlers_by_speed()
	
	# Connect signals for all battlers
	for battler in get_children():
		battler.send_attack.connect(_battler_sent_attack)
		battler.turn_finished.connect(_end_turn)
		battler.defeat.connect(_player_defeated)

	# Start the first turn
	get_child(0).start_turn()

# Sort and rearrange battlers in the scene tree by speed
func _sort_battlers_by_speed() -> void:
	var battlers = get_children()
	# Sort battlers by speed (descending order)
	battlers.sort_custom(_compare_speed)
	# Reorder children using move_child
	for i in range(battlers.size()):
		move_child(battlers[i], i)

func _compare_speed(a, b) -> bool:
	return a.current_stats.speed > b.current_stats.speed

# Handle the end of a turn
func _end_turn() -> void:
	# Move the current battler (index 0) to the last position
	move_child(get_child(0), get_child_count() - 1)
	# Start the next battler's turn
	get_child(0).start_turn()
	cur_battlers_moved += 1

# Handle an attack from a battler
func _battler_sent_attack(damage: int, target_index: int) -> void:
	var target = get_child(target_index)
	print("%s hit %s for %d damage" % [get_child(0).name, target.name, damage])
	target.damage(damage)
	target._refresh_labels()

func _player_defeated():
	print("Battle finished!")
	get_tree().quit()