extends Resource
class_name status_effect_applier

enum effects {POISON, REGENERATION, STIMULANT, BREATH_MINT, DROWSY, LAXATIVE}

var concentrations: Array[float]
var concentrations_in: Array[float]

func _ready() -> void:
    for i in range(len(effects)):
        concentrations.append(0)
        concentrations_in.append(0)

func update_concentrations(flow, volume, delta=1):
    """
    Updates the concentrations for all effect types.

    This is modeled like a mixing problem with many different solids being tracked.
    """
    for i in range(len(concentrations)):
        concentrations[i] = concentrations[i] + (flow / volume) * (concentrations_in[i] - concentrations[i]) * delta

func add_effect_dose(eff: effects, dose: float, vol: int):
    """
    Adds a dose of an effect.
    
    This acts similar to an impulse on the mixing tank.
    """
    concentrations[eff] += dose / vol

func modify_concentration_in(eff: effects, con: float):
    concentrations_in[eff] = con

func apply_poison(health: int):
    pass