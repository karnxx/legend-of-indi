extends Control

func _ready():
	BattleManager.connect("battle_started", Callable(self, "on_battle_start"))
	BattleManager.connect("turn_finished", Callable(self, "on_turn_finish"))
	BattleManager.connect("battle_ended", Callable(self, "on_battle_end"))

	for btn in $Moves.get_children():
		btn.pressed.connect(func():
			_on_move_pressed(btn))
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
	hide_all()
	$Moves.show()
	upd_move()
	update_attack_buttons()

func show_targets():
	hide_all()
	$Targets.show()

func update_attack_buttons():
	if BattleManager.awaiting_target:
		$Actions/plr_atk.hide()
		$Actions/fight.hide()
	else:
		$Actions/plr_atk.show()
		$Actions/fight.show()

func on_battle_start(is_trainer):
	upd_all()

func on_turn_finish():
	upd_all()
	show_action()

func on_battle_end(winner):
	hide()

func upd_all():
	upd_opponent()
	upd_player()

func upd_opponent():
	var pokee = BattleManager.opponent_poke
	var trainer = BattleManager.opponent_char
	if pokee != null and pokee.species != null:
		$Opponent/Pokemon/nam.text = pokee.species.name
		$Opponent/Pokemon/hp.text = str(pokee.current_hp) + "/" + str(pokee.stats["hp"])
	else:
		$Opponent/Pokemon/nam.text = ""
		$Opponent/Pokemon/hp.text = ""
	if trainer != null:
		$Opponent/Player/nam.text = trainer.name
		$Opponent/Player/hp.text = str(trainer.current_hp) + "/" + str(trainer.stats["hp"])
	else:
		$Opponent/Player/nam.text = ""
		$Opponent/Player/hp.text = ""

func upd_player():
	var poke = BattleManager.player_poke
	var char = BattleManager.player_char
	if poke != null and poke.species != null:
		$Player/Pokemon/nam.text = poke.species.name
		$Player/Pokemon/hp.text = str(poke.current_hp) + "/" + str(poke.stats["hp"])
	else:
		$Player/Pokemon/nam.text = ""
		$Player/Pokemon/hp.text = ""
	if char != null:
		$Player/Player/nam.text = char.name
		$Player/Player/hp.text = str(char.current_hp) + "/" + str(char.stats["hp"])
	else:
		$Player/Player/nam.text = ""
		$Player/Player/hp.text = ""

func upd_move():
	var moves = BattleManager.player_poke.moves
	for i in range($Moves.get_child_count()):
		var btn = $Moves.get_child(i)
		if i < moves.size() and moves[i] != null:
			btn.text = moves[i].name
			btn.set_meta("move", moves[i])
			btn.disabled = false
		else:
			btn.text = "---"
			btn.set_meta("move", null)
			btn.disabled = true

func _on_fight_pressed():
	show_move()

func _on_move_pressed(btn: Button):
	var move = btn.get_meta("move")
	if move == null:
		return
	BattleManager.player_pokemon_use_move(move)
	show_targets()
	update_attack_buttons()

func _on_plr_atk_pressed():
	BattleManager.player_char_use_move(BattleManager.player_char.basic_attack)
	show_targets()
	update_attack_buttons()

func _on_target_pokemon_pressed():
	BattleManager.resolve_player_action(BattleManager.opponent_poke)
	update_attack_buttons()

func _on_target_trainer_pressed():
	BattleManager.resolve_player_action(BattleManager.opponent_char)
	update_attack_buttons()
