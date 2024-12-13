extends Resource
class_name status_effect_applier

enum effects {POISON, REGENERATION, STIMULANT, BREATH_MINT, DROWSY, LAXATIVE}

var concentrations: Array[float]
var concentrations_in: Array[float]

# Status tank flow

func _ready() -> void:
    """
    Initializes the concentrations and incoming concentrations arrays for each effect type.

    This function is called when the resource is ready and sets up initial values for the
    concentration of each status effect (initialized to 0).

    Args:
        None
    """
    for i in range(len(effects)):
        concentrations.append(0)
        concentrations_in.append(0)

func update_concentrations(flow: float, volume: float, delta: float = 1) -> void:
    """
    Updates the concentrations for all effect types using the mixing equation.

    This function models how the concentration of each status effect changes over time,
    based on the incoming flow and volume of the tank. The change is computed by
    comparing the incoming concentration with the current concentration.

    Args:
        flow (float): The flow rate (L/turn) of the incoming fluid.
        volume (float): The total volume (L) of the tank.
        delta (float): The time step (turns) for updating the concentrations. Default is 1.

    Returns:
        void: This function updates the concentration of each effect type in-place.
    """
    for i in range(len(concentrations)):
        # inflow = outflow = flow
        concentrations[i] += (flow / volume) * (concentrations_in[i] - concentrations[i]) * delta

func add_effect_dose(eff: effects, dose: float, vol: int) -> void:
    """
    Adds a dose of an effect (like an instantaneous spike in concentration).
    
    This function simulates an instantaneous increase in the concentration of a given status effect
    by adding a dose to the system. This is analogous to a Dirac delta function where a dose is applied
    at a specific moment.

    Args:
        eff (effects): The type of status effect (e.g., POISON, REGENERATION).
        dose (float): The amount of the status fluid added to the system (mg).
        vol (int): The volume of the tank (L).

    Returns:
        void: This function modifies the concentration of the given effect type.
    """
    concentrations[eff] += dose / vol

func modify_concentration_in(eff: effects, con: float) -> void:
    """
    Sets the incoming concentration for a given effect type.

    This function allows you to change the concentration of a status effect that is flowing into the system.

    Args:
        eff (effects): The type of status effect (e.g., POISON).
        con (float): The new concentration value for the incoming status fluid (mg/L).

    Returns:
        void: This function updates the incoming concentration for the specified effect.
    """
    concentrations_in[eff] = con

# Application strategies

func _newtons_law_of_cooling(stat: float, approach: int, eff: effects, delta: int=1):
    return stat + delta * concentrations[eff] * (approach - stat)

func _rlc_circuit(stat: float, change_in_stat: float, inertia: float, damper: float, restorer: float, external_force: float, delta: float = 1.0) -> Array:
    """
    Simulates the behavior of an RLC circuit applied to status effects, using Euler's method.

    Args:
        stat (float): The current state value, representing the "charge" (q) in the system.
        inertia (float): Equivalent to inductance (L), representing resistance to rapid changes in the system.
        damper (float): Equivalent to resistance (R), representing energy dissipation.
        restorer (float): Equivalent to 1/capacitance (1/C), representing the restorative force on the system.
        external_force (float): Equivalent to voltage source (V(t)), representing an external influence on the system.
        delta (float, optional): The time step for Euler's integration. Defaults to 1.0.

    Returns:
        Array: A regular array containing the updated `stat` (charge) and `q_prime` (current).

    Raises:
        ValueError: If `inertia` is zero, as it would cause a division by zero in the calculations.
    """
    assert(inertia == 0.0, "Inertia (inductance) must be non-zero to avoid division by zero.")

    # Derivatives (q' and q'') for the system
    var q_prime = change_in_stat
    var q_double_prime = (1 / inertia) * (external_force - damper * q_prime - restorer * stat)

    # Euler's update for the system
    stat += q_prime * delta
    q_prime += q_double_prime * delta

    return [stat, q_prime]

func _multipler_if_significant(stat: float, eff: effects, significance: float):
    if concentrations[eff] > significance:
        return stat * (concentrations[eff] / significance)
    return stat

# Apply individual effects

func apply_poison(health: int, delta: int=1) -> int:
    return roundi(_newtons_law_of_cooling(health, 0, effects.POISON, delta))

func apply_regen(health: int, max_health: int, delta: int=1):
    return roundi(_newtons_law_of_cooling(health, max_health, effects.REGENERATION, delta))

