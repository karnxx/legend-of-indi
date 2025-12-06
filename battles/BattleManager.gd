extends Node

signal battle_started(is_trainer: bool)
signal battle_ended(winner_id: String)
signal turn_finished()

var player_char: PlayerData
var player_poke: PokemonInstance
var opponent_char
var opponent_poke: PokemonInstance
var is_trainer_battle: bool = false
var background_texture: Texture2D

func start_battle(p_char: PlayerData, p_poke: PokemonInstance, wild_poke: PokemonInstance, bg_name: String = ""):
	player_char = p_char
	player_poke = p_poke
	opponent_char = null
	opponent_poke = wild_poke
	is_trainer_battle = false
	bg_change(bg_name)
	emit_signal("battle_started", false)

func start_trainer_battle(p_char: PlayerData, p_poke: PokemonInstance, t_char: Trainer, t_poke: PokemonInstance, bg_name: String = ""):
	player_char = p_char
	player_poke = p_poke
	opponent_char = t_char
	opponent_poke = t_poke
	is_trainer_battle = true
	bg_change(bg_name)
	emit_signal("battle_started", true)

func player_char_use_move(move: MoveData):
	if player_char.stamina < move.stamina_cost:
		return
	execute_plr(player_char, opponent_poke, move)
	if opponent_poke.current_hp <= 0:
		end("player")
		return
	if is_trainer_battle:
		trainer_turn()
		plr_pkmn_turn()
	else:
		enemy_turn()
	emit_signal("turn_finished")

func player_pokemon_use_move(move: MoveData):
	if player_poke.stamina < move.stamina_cost:
		return
	pkmn_move(player_poke, opponent_poke, move)
	if opponent_poke.current_hp <= 0:
		end("player")
		return
	if is_trainer_battle:
		trainer_turn()
		enemy_turn()
	else:
		enemy_turn()
	emit_signal("turn_finished")

func trainer_use_move(move: MoveData):
	if opponent_char == null:
		return
	if opponent_char.stamina < move.stamina_cost:
		return
	execute_plr(opponent_char, player_poke, move)

func trainer_turn():
	if opponent_char == null:
		return
	var moves = opponent_char.moves
	if moves.size() == 0:
		return
	var m = moves[randi() % moves.size()]
	if opponent_char.stamina >= m.stamina_cost:
		execute_plr(opponent_char, player_poke, m)
		if player_poke.current_hp <= 0:
			end("trainer")
			return

func plr_pkmn_turn():
	var moves = player_poke.moves
	if moves.size() == 0:
		return
	var m = moves[randi() % moves.size()]
	if player_poke.stamina >= m.stamina_cost:
		pkmn_move(player_poke, opponent_poke, m)
		if opponent_poke.current_hp <= 0:
			end("player")
			return

func enemy_turn():
	var moves = opponent_poke.moves
	if moves.size() == 0:
		return
	var m = moves[randi() % moves.size()]
	if opponent_poke.stamina >= m.stamina_cost:
		pkmn_move(opponent_poke, player_poke, m)
		if player_poke.current_hp <= 0:
			end("enemy")
			return

func execute_plr(user: PlayerData, target_poke: PokemonInstance, move: MoveData):
	user.stamina -= stamina_per_Fat(user, move)
	apply_fat(user, move)
	var dmg = calc_usrvspoke(user, target_poke, move)
	target_poke.current_hp = max(0, target_poke.current_hp - dmg)
	apply_status(move, target_poke)

func pkmn_move(user_poke: PokemonInstance, target, move: MoveData):
	user_poke.stamina -= stamina_per_Fat(user_poke, move)
	apply_fat(user_poke, move)
	var dmg = calc_pokevsusr(user_poke, target, move)
	if target is PlayerData:
		target.current_hp = max(0, target.current_hp - dmg)
	else:
		target.current_hp = max(0, target.current_hp - dmg)
	apply_status(move, target)

func stamina_per_Fat(entity, move: MoveData) -> int:
	var base = move.stamina_cost
	var fatigue_mult = 1.0
	if entity.fatigue > fat_lim(entity):
		fatigue_mult = 1.2
	return int(ceil(base * fatigue_mult))

func apply_fat(entity, move: MoveData):
	var gain = move.stamina_cost * 0.25
	entity.fatigue += gain

func fat_lim(entity) -> float:
	if typeof(entity) == TYPE_OBJECT and entity is PlayerData:
		return float(entity.max_hp) * 1.5
	if typeof(entity) == TYPE_OBJECT and entity is PokemonInstance:
		return float(entity.stats["hp"]) * 1.5
	return 100.0

func fat_factor(entity) -> float:
	var limit = fat_lim(entity)
	var f = clamp(1.0 - (entity.fatigue / limit) * 0.30, 0.7, 1.0)
	return f

func calc_usrvspoke(user: PlayerData, target_poke: PokemonInstance, move: MoveData) -> int:
	var atk: int
	if user.stats.has("atk"):
		atk = user.stats["atk"]
	else:
		atk = user.level * 2

	var def = target_poke.stats["def"]

	if move.category == "special" or move.category == "ranged":
		if user.stats.has("spa"):
			atk = user.stats["spa"]
		else:
			atk = user.level * 2
		def = target_poke.stats["spd"]

	var base = (float(atk) / max(1, def)) * move.power
	base *= randf_range(0.9, 1.1)
	base *= element_mult(move.element, target_poke)
	base *= fat_factor(user)

	return int(round(base))


func calc_pokevsusr(user_poke: PokemonInstance, target, move: MoveData) -> int:
	var atk = user_poke.stats["atk"]
	var def = target.stats["def"]
	if move.category == "special" or move.category == "ranged":
		atk = user_poke.stats["spa"]
		def = target.stats["spd"]
	var base = (float(atk) / max(1, def)) * move.power
	base *= randf_range(0.9, 1.1)
	if target is PlayerData:
		base *= element_mult(move.element, target)
	else:
		base *= element_mult(move.element, target)
	base *= fat_factor(user_poke)
	return int(round(base))

func element_mult(move_element: ElementData, target) -> float:
	if move_element == null:
		return 1.0
	var mult = 1.0
	var target_types := []
	if target is PokemonInstance:
		for t in target.species.elements:
			target_types.append(t)
	elif target is PlayerData:
		if target.element != null:
			target_types.append(target.element)
	for tt in target_types:
		if move_element.strong_against.has(tt):
			mult *= 2.0
		if move_element.weak_against.has(tt):
			mult *= 0.5
		if move_element.resists.has(tt):
			mult *= 0.5
		if move_element.immune_to.has(tt):
			mult *= 0.0
	return mult

func apply_status(move: MoveData, target):
	if move.inflicts_status == null:
		return
	if randf() <= move.inflict_chance:
		target.statuses.append(move.inflicts_status)

func bg_change(name: String):
	if name == "":
		return
	var path = "res://battle_backgrounds/" + name
	if ResourceLoader.exists(path):
		background_texture = load(path)

func end(winner_tag: String):
	emit_signal("battle_ended", winner_tag)
