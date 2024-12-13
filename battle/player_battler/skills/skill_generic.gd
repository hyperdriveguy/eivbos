extends Resource
class_name battler_skill

enum skill_type_set {STATUS_INFLICT, DAMAGE_STATUS_INFLICT, AUDIENCE_ATTACK}

var skill_type: skill_type_set
@export var skill_name: String = "Skill"
