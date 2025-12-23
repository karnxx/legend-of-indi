extends Node

signal battle_started(is_trainer: bool)
signal battle_ended(winner_id: String)
signal turn_finished()

var player_char
var player_poke
var opponent_char
var opponent_poke
var is_trainer_battle := false
var awaiting_target := false
var pending_move
var pending_user

func start_trainer_battle(p_char, p_poke, t_char, t_poke):
	player_char = p_char
	player_poke = p_poke
	opponent_char = t_char
	opponent_poke = t_poke
	is_trainer_battle = true
	if player_char.current_hp == null: player_char.hp = player_char.stats["hp"]
	if player_poke.current_hp == null: player_poke.current_hp = player_poke.stats["hp"]
	if opponent_char.current_hp == null: opponent_char.hp = opponent_char.stats["hp"]
	if opponent_poke.current_hp == null: opponent_poke.current_hp = opponent_poke.stats["hp"]
	emit_signal("battle_started", true)

func player_pokemon_use_move(move):
	pending_move = move
	pending_user = player_poke
	awaiting_target = true

func player_char_use_move(move):
	pending_move = move
	pending_user = player_char
	awaiting_target = true

func resolve_player_action(target):
	if not awaiting_target:
		return
	awaiting_target = false
	_execute_move(pending_user, target, pending_move)
	check_end()
	opponent_turn()
	emit_signal("turn_finished")

func _execute_move(user, target, move):
	var dmg = move.power
	target.current_hp -= dmg


func get_turn_order():
	var units := []
	if player_char: units.append(player_char)
	if player_poke: units.append(player_poke)
	if opponent_char: units.append(opponent_char)
	if opponent_poke: units.append(opponent_poke)

	for i in range(units.size()):
		for j in range(i + 1, units.size()):
			if units[j].stats["spe"] > units[i].stats["spe"]:
				var temp = units[i]
				units[i] = units[j]
				units[j] = temp

	return units

func opponent_turn():
	var turn_order = get_turn_order()
	for unit in turn_order:
		if unit == player_char or unit == player_poke:
			continue
		var move = unit.moves.pick_random()
		var targets := []
		if player_char.current_hp > 0: targets.append(player_char)
		if player_poke.current_hp > 0: targets.append(player_poke)
		if targets.size() == 0:
			continue
		var target = targets[randi() % targets.size()]
		_execute_move(unit, target, move)
		check_end()

func check_end():
	if (player_char.current_hp <= 0 and player_poke.current_hp <= 0):
		emit_signal("battle_ended", "enemy")
	elif (opponent_char and opponent_char.current_hp <= 0 and opponent_poke.current_hp <= 0):
		emit_signal("battle_ended", "player")
