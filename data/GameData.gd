extends Node

var elements: Array[ElementData] = []
var statuses: Array[StatusEffect] = []
var moves: Array[MoveData] = []
var actions: Array[ActionData] = []
var natures: Array[NatureData] = []
var personalities: Array[PersonalityData] = []
var reversals: Array[ReversalData] = []
var species: Array[PokemonSpecies] = []

func _ready():

	elements.append(load("res://data/element/elements/Fire.tres"))
#	statuses = load_all("res://data/status_effects/effects")
#	moves = load_all("res://data/moves/moves")
#	actions = load_all("res://data/actions/actions")
#	natures = load_all("res://data/nature/natures")
#	personalities = load_all("res://data/personality/personalities")
#	reversals = load_all("res://data/reversals/reversal")
#	species = load_all("res://data/mons/mons")

func _process(delta: float) -> void:
	print(elements)
