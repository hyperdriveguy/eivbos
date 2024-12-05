extends Node2D

signal primary_action_fire
signal secondary_action_fire
signal primary_special_fire
signal secondary_special_fire

enum {NO_ACTION, PRIMARY_ACTION, SECONDARY_ACTION, PRIMARY_SPECIAL, SECONDARY_SPECIAL}

var input_dev: DeviceInput
var listen_inputs: bool = false
var asking_to_confirm = NO_ACTION

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if listen_inputs and asking_to_confirm == NO_ACTION:
		if input_dev.is_action_just_pressed("action_primary"):
			set_button_animation("confirm primary action")
		elif input_dev.is_action_just_pressed("action_secondary"):
			set_button_animation("confirm secondary action")
		elif input_dev.is_action_just_pressed("special_primary"):
			set_button_animation("confirm primary special")
		elif input_dev.is_action_just_pressed("special_secondary"):
			set_button_animation("confirm secondary special")
	elif listen_inputs:
		match asking_to_confirm:
			PRIMARY_ACTION:
				if input_dev.is_action_just_pressed("action_primary"):
					disable()
					primary_action_fire.emit()
				elif input_dev.is_action_just_pressed("action_secondary") or input_dev.is_action_just_pressed("special_primary") or input_dev.is_action_just_pressed("special_secondary"):
					asking_to_confirm = NO_ACTION
			SECONDARY_ACTION:
				if input_dev.is_action_just_pressed("action_secondary"):
					disable()
					secondary_action_fire.emit()
				elif input_dev.is_action_just_pressed("action_primary") or input_dev.is_action_just_pressed("special_primary") or input_dev.is_action_just_pressed("special_secondary"):
					asking_to_confirm = NO_ACTION


func enable():
	visible = true
	listen_inputs = true

func disable():
	visible = false
	listen_inputs = false
	asking_to_confirm = NO_ACTION

func set_button_labels(primary_action:String, secondary_action:String, primary_special:String, secondary_special:String):
	$PrimaryActionLabel.text = primary_action
	$SecondaryActionLabel.text = secondary_action
	$PrimarySpecialLabel.text = primary_special
	$SecondarySpecialLabel.text = secondary_special

func set_button_animation(anim:String):
	if input_dev.is_keyboard():
		$ButtonsAnimatedSprite.animation = "key " + anim
	else:
		$ButtonsAnimatedSprite.animation = "joy " + anim

