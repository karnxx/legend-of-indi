extends Resource
class_name PokemonSpecies

@export var name: String
@export var types: Array[ElementData]

@export var base_stats := {
	"hp":50, "atk":50, "def":50, "spa":50, "spd":50, "spe":50
}

@export var learnset: Array[Dictionary]
@export var actions: Array[ActionData]
@export var reversals: Array[ReversalData]
