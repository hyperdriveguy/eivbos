extends Node2D

var is_keyboard: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_button_labels(primary_action:String, secondary_action:String, primary_special:String, secondary_special:String):
	$PrimaryActionLabel.text = primary_action
	$SecondaryActionLabel.text = secondary_action
	$PrimarySpecialLabel.text = primary_special
	$SecondarySpecialLabel.text = secondary_special

func set_button_animation(anim:String):
	if is_keyboard:
		$ButtonsAnimatedSprite.animation = "key " + anim
	else:
		$ButtonsAnimatedSprite.animation = "joy " + anim

