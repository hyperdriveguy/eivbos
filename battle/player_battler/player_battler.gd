extends Node2D
class_name PlayerBattler

signal send_attack(damage: int, target: int)
signal turn_finished

@export var player_input_id: int
@export var permanent_stats: battler_stats

@onready var temporary_stats: battler_stats = permanent_stats.duplicate()
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
	$AnimationPlayer.play_backwards("idle")
	$ActionIndicator.set_button_labels("Attack", "Skill", "Appeal", "Displease")
	if player_input_id == -1:
		$ActionIndicator.is_keyboard = true
	$ActionIndicator.set_button_animation("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_turn:
		if input.is_action_just_pressed("attack_battle"):
			send_attack.emit(temporary_stats.strength, -1)
			Input.start_joy_vibration(player_input_id,0.3,.1,.13)
			end_turn()

func _refresh_labels():
	hp_label.text = "HP: " + str(temporary_stats.health) + "/" + str(permanent_stats.health)

func start_turn():
	is_turn = true
	$ActionIndicator.visible = true

func end_turn():
	$ActionIndicator.visible = false
	is_turn = false
	turn_finished.emit()

