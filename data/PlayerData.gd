extends Node
@export var hp : int
@export var max_hp : int



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
