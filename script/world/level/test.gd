extends Node2D
var nad 
func _process(delta: float) -> void:
	await get_tree().create_timer(1).timeout
	nad = MonGenerator.generate(preload("res://data/mons/mons/Sandalmander.tres"), 1)
	print(nad.species.name)
