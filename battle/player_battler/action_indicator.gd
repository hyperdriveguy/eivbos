extends Node2D

signal primary_action_fire
signal secondary_action_fire
signal primary_special_fire
signal secondary_special_fire

enum { NO_ACTION, PRIMARY_ACTION, SECONDARY_ACTION, PRIMARY_SPECIAL, SECONDARY_SPECIAL }

var input_dev: DeviceInput
var listen_inputs: bool = false
var asking_to_confirm = NO_ACTION

func _ready() -> void:
	disable()

func _process(_delta: float) -> void:
	if not listen_inputs:
		return

	if asking_to_confirm == NO_ACTION:
		_handle_initial_input()
	else:
		_handle_confirmation_input()

func enable():
	visible = true
	listen_inputs = true

func disable():
	visible = false
	listen_inputs = false
	asking_to_confirm = NO_ACTION
	set_button_animation("idle")

func set_button_labels(primary_action: String, secondary_action: String, primary_special: String, secondary_special: String):
	$PrimaryActionLabel.text = primary_action
	$SecondaryActionLabel.text = secondary_action
	$PrimarySpecialLabel.text = primary_special
	$SecondarySpecialLabel.text = secondary_special

func set_button_animation(anim: String):
	if input_dev == null:
		return
	var prefix = "key " if input_dev.is_keyboard() else "joy "
	$ButtonsAnimatedSprite.animation = prefix + anim
	$ButtonsAnimatedSprite.play()

# Helper Functions
func _handle_initial_input():
	if input_dev.is_action_just_pressed("action_primary"):
		set_button_animation("confirm primary action")
		asking_to_confirm = PRIMARY_ACTION
	elif input_dev.is_action_just_pressed("action_secondary"):
		set_button_animation("confirm secondary action")
		asking_to_confirm = SECONDARY_ACTION
	elif input_dev.is_action_just_pressed("special_primary"):
		set_button_animation("confirm primary special")
		asking_to_confirm = PRIMARY_SPECIAL
	elif input_dev.is_action_just_pressed("special_secondary"):
		set_button_animation("confirm secondary special")
		asking_to_confirm = SECONDARY_SPECIAL

func _handle_confirmation_input():
	match asking_to_confirm:
		PRIMARY_ACTION:
			_process_action("action_primary", primary_action_fire)
		SECONDARY_ACTION:
			_process_action("action_secondary", secondary_action_fire)
		PRIMARY_SPECIAL:
			_process_action("special_primary", primary_special_fire)
		SECONDARY_SPECIAL:
			_process_action("special_secondary", secondary_special_fire)

func _process_action(action: String, signal_to_emit):
	if input_dev.is_action_just_pressed(action):
		disable()
		signal_to_emit.emit()
	elif _any_other_action_pressed(action):
		asking_to_confirm = NO_ACTION
		set_button_animation("idle")

func _any_other_action_pressed(exclude: String) -> bool:
	var actions = ["action_primary", "action_secondary", "special_primary", "special_secondary"]
	actions.erase(exclude)
	for action in actions:
		if input_dev.is_action_just_pressed(action):
			return true
	return false
