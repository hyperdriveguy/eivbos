extends Resource
class_name battler_stats

@export var health: int = 10
@export var strength: int = 5
@export var skill: int = 5
@export var speed: int = 5
@export var awareness: int = 5

# Audience interaction
@export var rizz: int = 5

# Status effect application
var status_applier: status_effect_applier = status_effect_applier.new()
@export var flushability: int = 1
@export var status_tank: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
