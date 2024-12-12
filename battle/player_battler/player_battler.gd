extends Node2D
class_name PlayerBattler

signal send_attack(damage: int, target: int)
signal turn_finished
signal defeat

@export var player_input_id: int
@export var permanent_stats: battler_stats

@onready var current_stats: battler_stats = permanent_stats.duplicate()
@onready var hp_label: Label = $HPLabel

var is_turn = false
var input

# Child called ActionsUI with an HBoxContainer child and three buttons as children

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var devices = Input.get_connected_joypads()
	# also consider keyboard player
	devices.append(-1)
	print("Devices: ", devices)

	print("rizz: ", current_stats.rizz)
	_refresh_labels()
	$AnimationPlayer.play("idle")

	# Initialize button hints
	$ActionIndicator.input_dev = DeviceInput.new(player_input_id)
	_main_menu()

func _obliterate_signal_bind(sig: Signal):
	for conn in sig.get_connections():
		sig.disconnect(conn.callable)

func _disconnect_actions():
	_obliterate_signal_bind($ActionIndicator.primary_action_fire)
	_obliterate_signal_bind($ActionIndicator.secondary_action_fire)
	_obliterate_signal_bind($ActionIndicator.primary_special_fire)
	_obliterate_signal_bind($ActionIndicator.secondary_special_fire)

func _main_menu():
	$ActionIndicator.set_button_labels("Attack", "Skill", "Appeal", "Displease")
	$ActionIndicator.set_button_animation("idle")
	$ActionIndicator.primary_action_fire.connect(_attack_action)
	$ActionIndicator.secondary_action_fire.connect(_skill_menu_action)
	$ActionIndicator.primary_special_fire.connect(_attack_action)
	$ActionIndicator.secondary_special_fire.connect(_attack_action)

func _skills_menu():
	$ActionIndicator.set_button_labels("Skill 1", "Skill 2", "<- Back", "Skill 3")
	$ActionIndicator.set_button_animation("idle")
	# $ActionIndicator.primary_action_fire.connect()
	# $ActionIndicator.secondary_action_fire.connect()
	$ActionIndicator.primary_special_fire.connect(_return_to_main_menu)
	# $ActionIndicator.secondary_special_fire.connect()
	$ActionIndicator.enable()

func _return_to_main_menu():
	_disconnect_actions()
	_main_menu()
	$ActionIndicator.enable()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _refresh_labels():
	hp_label.text = "HP: " + str(current_stats.health) + "/" + str(permanent_stats.health)

func start_turn():
	is_turn = true
	$ActionIndicator.enable()

func end_turn():
	$ActionIndicator.disable()
	is_turn = false
	turn_finished.emit()

func damage(raw_damage: int):
	assert(raw_damage >= 0)
	current_stats.health -= raw_damage
	if current_stats.health <= 0:
		current_stats.health = 0
		defeat.emit()
	_refresh_labels()

func _attack_action():
	send_attack.emit(current_stats.strength, -1)
	Input.start_joy_vibration(player_input_id,0.3,.1,.13)
	end_turn()

func _skill_menu_action():
	_disconnect_actions()
	_skills_menu()
