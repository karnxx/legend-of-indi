extends Resource
class_name PokemonInstance

@export var species: PokemonSpecies
@export var level: int = 1
@export var nature: NatureData
@export var personality: PersonalityData
@export var current_form: Resource

@export var stats := {
	"hp":0, "atk":0, "def":0, "spa":0, "spd":0, "spe":0
}

@export var current_hp: int = 0
@export var stamina: int = 100
@export var fatigue: int = 0
@export var statuses: Array[StatusEffect] = []

@export var moves: Array[MoveData] = []
