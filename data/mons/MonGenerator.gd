extends Node

var natures
var personalities

func _ready() -> void:
	personalities = GameData.personalities
	natures = GameData.natures

func generate(species: PokemonSpecies, level: int) -> PokemonInstance:
	var inst := PokemonInstance.new()
	
	inst.species = species
	inst.level = level
	inst.nature = natures.pick_random()
	inst.personality = personalities.pick_random()
	inst.current_form = null
	
	var stat_enum_map = {
		"atk": NatureData.Stat.ATK,
		"def": NatureData.Stat.DEF,
		"spa": NatureData.Stat.SPA,
		"spd": NatureData.Stat.SPD,
		"spe": NatureData.Stat.SPE,
		"hp": NatureData.Stat.HP
	}
	
	var ivs := {}
	for stat in species.base_stats.keys():
		ivs[stat] = randf_range(0.94, 1.06)
	
	var final_stats := {}
	for stat in species.base_stats.keys():
		var base = species.base_stats[stat]
		var scaled = base * (1.0 + (level / 100.0))
		var iv_scaled = scaled * ivs[stat]
		
		var nat_inc = inst.nature.inc_stat
		var nat_dec = inst.nature.dec_stat
		var stat_enum = stat_enum_map[stat]
		
		if stat_enum == nat_inc:
			iv_scaled *= 1.1
		elif stat_enum == nat_dec:
			iv_scaled *= 0.9
		
		final_stats[stat] = int(iv_scaled)
	
	inst.stats = final_stats
	inst.current_hp = final_stats["hp"]
	inst.stamina = 100
	inst.fatigue = 0
	inst.statuses = []
	
	var learned_moves: Array[MoveData] = []
	for entry in species.learnset:
		if entry.level <= level:
			learned_moves.append(entry.move)
	
	if learned_moves.size() > 4:
		inst.moves = learned_moves.slice(learned_moves.size() - 4, learned_moves.size())
	else:
		inst.moves = learned_moves
	
	return inst
