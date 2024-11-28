extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_button_labels(primary_action:String, secondary_action:String, primary_special:String, secondary_special:String):
	$PrimaryActionLabel.text = primary_action
	$SecondaryActionLabel.text = secondary_action
	$PrimarySpecialLabel.text = primary_special
	$SecondarySpecialLabel.text = secondary_special