extends battler_skill
class_name status_inflicter

@export var effect: String
@export var intensity: float = 0.5

func activate():
    return ["status", effect, intensity]
