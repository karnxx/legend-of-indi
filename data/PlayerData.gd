extends Node
enum fighting_styles {south,north,east,west}

@export var nayme: String = "Yur"
@export var current_hp: int
@export var level := 1
@export var max_hp: int
@export var stamina: int
@export var max_stamina: int
@export var fatigue: float
@export var element: ElementData
@export var moves: Array[MoveData] = [preload("res://data/moves/plr_moves/Punch.tres")]
@export var stats := {
	"hp":1.0, "atk":1.0, "def":1.0, "spa":1.0, "spd":1.0, "spe":1.0
}
var basic_attack = preload("res://data/moves/plr_moves/Punch.tres")

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
