extends battler_skill
class_name status_inflicter

@export var effect: status_effect_applier.effects
@export var dosage: float = 20

func activate(sig: Signal, cur_stats: battler_stats, target: int=-1):
    sig.emit(effect, dosage, cur_stats.status_tank, target)
