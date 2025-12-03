extends Resource
class_name StatusEffect
@export var display_name: String
@export var kind: String
@export var image : ImageTexture
enum ElementType { NORMAL, FIRE, WATER, GRASS }
@export var element_type: ElementType


@export var stat_mult := {
	"atk":1.0, "def":1.0, "spa":1.0, "spd":1.0, "spe":1.0
}

@export var hp_change_per_turn: int
@export var stamina_change_per_turn: int
@export var stamina_multiplier: float
@export var fatigue_per_action: int

@export var can_attack: bool = true
@export var can_dodge: bool = true
@export var self_harm_chance: float = 0.0

@export var duration_min: int = 0
@export var duration_max: int = 0
