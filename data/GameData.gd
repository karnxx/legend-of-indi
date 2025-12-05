extends Node

var elements: Array
var statuses: Array
var moves: Array
var actions: Array
var natures: Array
var personalities: Array
var reversals: Array
var species: Array

func _ready():
	elements = load_all("res://data/element/elements" )
	statuses = load_all("res://data/status_effects/effects")
	moves = load_all("res://data/moves/moves" )
	actions = load_all("res://data/actions/actions" )
	natures = load_all("res://data/nature/natures")
	personalities = load_all("res://data/personality/personalities" )
	reversals = load_all("res://data/reversals/reversal" )
	species = load_all("res://data/mons/mons")


func load_all(path: String) -> Array:
	var out = []
	var dir = DirAccess.open(path)
	if not dir:
		print("Failed to open directory:", path)
		return out

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var res_path = path + "/" + file_name
			if FileAccess.file_exists(res_path):
				var res = load(res_path)
				if res != null:
					out.append(res)
		file_name = dir.get_next()
	dir.list_dir_end()
	return out
