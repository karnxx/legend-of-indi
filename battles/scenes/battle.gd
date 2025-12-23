extends Control

var pkmn_move_selected := false
var plr_move_selected := false

func _ready():
	BattleManager.connect("battle_started", Callable(self, "on_battle_start"))
	BattleManager.connect("turn_finished", Callable(self, "on_turn_finish"))
	BattleManager.connect("battle_ended", Callable(self, "on_battle_end"))
	BattleManager.connect("log_event", Callable(self, "on_log_event"))
	show_action()

func hide_all():
	$Actions.hide()
	$Moves.hide()
	$Targets.hide()

func show_action():
	hide_all()
	$Actions.show()
	upd_all()
	update_attack_buttons()

func show_move():
	if BattleManager.player_poke == null:
		return
	hide_all()
	$Moves.show()
	upd_move()

func show_targets():
	hide_all()
	$Targets.show()

func update_attack_buttons():
	if not BattleManager.player_pokemon_action_done and BattleManager.player_poke != null:
		$Actions/plr_atk.hide()
	elif not BattleManager.player_trainer_action_done and BattleManager.player_char != null:
		$Actions/plr_atk.show()
	else:
		hide_all()

func upd_all():
	upd_opponent()
	upd_player()

func upd_opponent():
	var pokee = BattleManager.opponent_poke
	var trainer = BattleManager.opponent_char

	$Opponent/Pokemon.visible = pokee != null
	$Opponent/Player.visible = trainer != null

	if pokee:
		$Opponent/Pokemon/nam.text = pokee.species.name
		$Opponent/Pokemon/hp.text = str(pokee.current_hp) + "/" + str(pokee.stats["hp"])

	if trainer:
		$Opponent/Player/nam.text = trainer.name
		$Opponent/Player/hp.text = str(trainer.current_hp) + "/" + str(trainer.stats["hp"])

func upd_player():
	var poke = BattleManager.player_poke
	var char = BattleManager.player_char

	$Player/Pokemon.visible = poke != null
	$Player/Player.visible = char != null

	if poke:
		$Player/Pokemon/nam.text = poke.species.name
		$Player/Pokemon/hp.text = str(poke.current_hp) + "/" + str(poke.stats["hp"])

	if char:
		$Player/Player/nam.text = char.name
		$Player/Player/hp.text = str(char.current_hp) + "/" + str(char.stats["hp"])

func upd_move():
	var poke = BattleManager.player_poke
	if poke == null:
		return
	var moves = poke.moves
	for i in range(4):
		var btn = $Moves.get_child(i)
		if i < moves.size():
			btn.text = moves[i].name
			btn.disabled = false
		else:
			btn.text = "---"
			btn.disabled = true

func _on_fight_pressed():
	show_move()

func _on_move1_pressed(): select_move(0)
func _on_move2_pressed(): select_move(1)
func _on_move3_pressed(): select_move(2)
func _on_move4_pressed(): select_move(3)

func select_move(i):
	var poke = BattleManager.player_poke
	if poke and i < poke.moves.size():
		BattleManager.player_select_action(poke, poke.moves[i])
		show_targets()

func _on_plr_atk_pressed():
	var char = BattleManager.player_char
	if char:
		BattleManager.player_select_action(char, char.basic_attack)
		show_targets()

func _on_target_pokemon_pressed():
	var t = BattleManager.opponent_poke
	if t:
		BattleManager.resolve_player_action(t)
		after_target()

func _on_target_trainer_pressed():
	var t = BattleManager.opponent_char
	if t:
		BattleManager.resolve_player_action(t)
		after_target()

func after_target():
	if BattleManager.player_actions_done():
		hide_all()
	else:
		show_action()

func on_battle_start(is_trainer):
	$Log.text = "Battle started\n"
	show()
	upd_all()
	show_action()

func on_turn_finish():
	$Log.text += "Turn ended\n\n"
	upd_all()
	show_action()

func on_battle_end(winner):
	$Log.text += winner.capitalize() + " wins\n"
	print(winner)
	hide()

func on_log_event(text):
	$Log.text += text + "\n"
