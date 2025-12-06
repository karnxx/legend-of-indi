extends Node
enum fighting_styles {south,north,east,west}
@export var hp : int
@export var max_hp : int
@export var stamina : int
@export var max_stamina :int
@export var fatigue : int
@export var statuses : StatusEffect
@export var moves: Array[MoveData] = [preload("res://data/moves/moves/Tackle.tres")] 
@export var stat := {
	"hp":1.0, "atk":1.0, "def":1.0, "spa":1.0, "spd":1.0, "spe":1.0
}
@export var my_element : ElementData.ElementType
@export var fighting_style : fighting_styles
@export var player_name: String
@export var money: int = 0

@export var party: Array[Resource] = []
@export var storage: Array[Resource] = []

@export var inventory: Dictionary = {
	"healing": {},
	"battle": {},
	"key": {},
	"misc": {}
}

@export var pokedex_seen: Array[Resource] = []
@export var pokedex_caught: Array[Resource] = []

@export var world_flags := {}
