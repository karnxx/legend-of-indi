extends Node

signal battle_started(is_trainer: bool)
signal battle_ended(winner_id: String)
signal turn_finished()
signal log_event(text)

class Action:
	var user
	var target
	var move

var player_char
var player_poke
var opponent_char
var opponent_poke
var is_trainer_battle := false

var pending_actions := []
var awaiting_target := false
var pending_user = null
var pending_move = null
var player_pokemon_action_done := false
var player_trainer_action_done := false

func start_trainer_battle(p_char, p_poke, t_char, t_poke):
	player_char = p_char
	player_poke = p_poke
	opponent_char = t_char
	opponent_poke = t_poke
	is_trainer_battle = true
	pending_actions.clear()
	player_pokemon_action_done = false
	player_trainer_action_done = false
	emit_signal("battle_started", true)

func add_pending_action(user, target, move):
	var act = Action.new()
	act.user = user
	act.target = target
	act.move = move
	pending_actions.append(act)

func player_select_action(user, move):
	if awaiting_target:
		return
	if user == null or user.current_hp <= 0:
		return
	pending_user = user
	pending_move = move
	awaiting_target = true

func resolve_player_action(target):
	if not awaiting_target:
		return
	if target == null or target.current_hp <= 0:
		return

	awaiting_target = false
	add_pending_action(pending_user, target, pending_move)

	if pending_user == player_poke:
		player_pokemon_action_done = true
	elif pending_user == player_char:
		player_trainer_action_done = true

	pending_user = null
	pending_move = null

	check_and_resolve_turn()

func player_actions_done():
	var poke_ok = player_poke == null or player_pokemon_action_done
	var char_ok = player_char == null or player_trainer_action_done
	return poke_ok and char_ok

func check_and_resolve_turn():
	if player_actions_done():
		enemy_choose_actions()
		resolve_turn()
		player_pokemon_action_done = false
		player_trainer_action_done = false

func enemy_choose_actions():
	if opponent_poke and opponent_poke.current_hp > 0:
		var m = opponent_poke.moves.pick_random()
		add_pending_action(opponent_poke, choose_target_for_enemy(), m)

	if opponent_char and opponent_char.current_hp > 0:
		var m = opponent_char.moves.pick_random()
		add_pending_action(opponent_char, choose_target_for_enemy(), m)

func choose_target_for_enemy():
	var targets := []
	if player_poke and player_poke.current_hp > 0:
		targets.append(player_poke)
	if player_char and player_char.current_hp > 0:
		targets.append(player_char)
	return targets.pick_random()

func resolve_turn():
	pending_actions.sort_custom(Callable(self, "_sort_by_speed"))
	for act in pending_actions:
		_execute_move(act.user, act.target, act.move)
	pending_actions.clear()
	cleanup_dead()
	emit_signal("turn_finished")
	check_end()

func _execute_move(user, target, move):
	if user == null or target == null:
		return
	if user.current_hp <= 0 or target.current_hp <= 0:
		return

	var dmg = move.power
	target.current_hp -= dmg

	var user_name := ""
	var target_name := ""

	if user is PokemonInstance:
		user_name = user.species.name
	else:
		user_name = user.name

	if target is PokemonInstance:
		target_name = target.species.name
	else:
		target_name = target.name

	emit_signal("log_event", user_name + " hits " + target_name + " for " + str(dmg))

func _sort_by_speed(a, b):
	return a.user.stats["spe"] > b.user.stats["spe"]

func cleanup_dead():
	if player_poke and player_poke.current_hp <= 0:
		emit_signal("log_event", player_poke.species.name + " fainted")
		player_poke = null

	if player_char and player_char.current_hp <= 0:
		emit_signal("log_event", player_char.name + " fainted")
		player_char = null

	if opponent_poke and opponent_poke.current_hp <= 0:
		emit_signal("log_event", opponent_poke.species.name + " fainted")
		opponent_poke = null

	if opponent_char and opponent_char.current_hp <= 0:
		emit_signal("log_event", opponent_char.name + " fainted")
		opponent_char = null

func check_end():
	if opponent_char == null and opponent_poke == null:
		emit_signal("battle_ended", "player")
	elif player_char == null and player_poke == null:
		emit_signal("battle_ended", "enemy")
