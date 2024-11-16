extends Node2D
class_name PlayerBattler

signal send_attack(damage: int)
signal turn_finished

@export var player_input_id: int
@export var permanent_stats: battler_stats

@onready var temporary_stats: battler_stats = permanent_stats
@onready var hp_label: Label = $HPLabel

var is_turn = false
var input

# Child called ActionsUI with an HBoxContainer child and three buttons as children

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var devices = Input.get_connected_joypads()
	# also consider keyboard player
	devices.append(-1)
	print(devices)

	input = DeviceInput.new(player_input_id)
	print("rizz: ", temporary_stats.rizz)
	_refresh_labels()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_turn:
		if input.is_action_just_pressed("attack_battle"):
			is_turn = false
			send_attack.emit(temporary_stats.strength)
			Input.start_joy_vibration(player_input_id,0.3,.1,.13)
			turn_finished.emit()

func _refresh_labels():
	hp_label.text = "HP: " + str(temporary_stats.health)
