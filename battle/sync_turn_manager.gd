extends Node


@onready var _battler0 = get_child(0)
@onready var _battler1 = get_child(1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_battler0.send_attack.connect(_battler0_sent_attack)
	_battler1.send_attack.connect(_battler1_sent_attack)
	print('0: ', _battler0.temporary_stats.speed)
	print('1: ', _battler1.temporary_stats.speed)
	if _battler1.temporary_stats.speed > _battler0.temporary_stats.speed:
		move_child(_battler1, 0)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _battler0_sent_attack(damage: int):
	print("0 hit 1 for ", damage)
	_battler1.temporary_stats.health -= damage
	_battler1._refresh_labels()

func _battler1_sent_attack(damage: int):
	print("1 hit 0 for ", damage)
	_battler0.temporary_stats.health -= damage
	_battler0._refresh_labels()