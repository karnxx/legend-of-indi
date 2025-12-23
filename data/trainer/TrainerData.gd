extends Resource
class_name Trainer

@export var name: String = "Trainer"
@export var current_hp: int = 100
@export var max_hp: int = 100
@export var stamina: int = 100
@export var max_stamina: int = 100
@export var fatigue: int = 0
@export var moves: Array[MoveData] = [preload("res://data/moves/plr_moves/Punch.tres")]
var stats := {
	"hp":1.0, "atk":1.0, "def":1.0, "spa":1.0, "spd":1.0, "spe":0.8
	}
