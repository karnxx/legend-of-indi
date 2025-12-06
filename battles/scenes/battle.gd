extends Control


func _ready():
	await get_tree().create_timer(1).timeout
	BattleManager.connect("battle_started", Callable(self, "on_batle_Start"))
	BattleManager.connect("turn_finished", Callable(self, "on_turn_finish"))
	BattleManager.connect("battle_ended", Callable(self, "on_battle_end"))

	hide_all()
	show_Action()

func on_batle_Start(is_trainer):
	visible = true
	upd_all()

func on_turn_finish():
	upd_all()

func on_battle_end(winner):
	visible = false

func hide_all():
	$Actions.hide()
	$Moves.hide()

func show_Action():
	hide_all()
	$Actions.show()
	upd_all()

func show_move():
	hide_all()
	$Moves.show()
	upd_move()

func upd_all():
	upd_opponent()
	upd_plr()

func upd_opponent():
	var pokee = BattleManager.opponent_poke
	var trainer = BattleManager.opponent_char

	if pokee:
		$Opponent/Pokemon/nam.text = pokee.species.name
		$Opponent/Pokemon/hp.text = str(pokee.current_hp) + "/" + str(pokee.stats["hp"])
		$Opponent/Pokemon/stm.text = str(pokee.stamina) + "/" + str(int(pokee.stats["hp"] * pokee.multiplier_stm))
		$Opponent/Pokemon/fat.text = str(int(pokee.fatigue))
		$Opponent/Pokemon/element.text = get_eltext(pokee.species.element_type)
	else:
		$Opponent/Pokemon/nam.text = ""
		$Opponent/Pokemon/hp.text = ""
		$Opponent/Pokemon/stm.text = ""
		$Opponent/Pokemon/fat.text = ""
		$Opponent/Pokemon/element.text = ""

	if trainer:
		$Opponent/Player/nam.text = trainer.name
		$Opponent/Player/hp.text = str(trainer.hp) + "/" + str(trainer.max_hp)
		$Opponent/Player/stm.text = str(trainer.stamina) + "/" + str(trainer.max_stamina)
		$Opponent/Player/fat.text = str(int(trainer.fatigue))
	else:
		$Opponent/Player/nam.text = ""
		$Opponent/Player/hp.text = ""
		$Opponent/Player/stm.text = ""
		$Opponent/Player/fat.text = ""

func upd_plr():
	var pokee = BattleManager.player_poke
	var trainer = BattleManager.player_char

	if pokee:
		$Player/Pokemon/nam.text = pokee.species.name
		$Player/Pokemon/hp.text = str(pokee.current_hp) + "/" + str(pokee.stats["hp"])
		$Player/Pokemon/stm.text = str(pokee.stamina) + "/" + str(int(pokee.stats["hp"] * pokee.multiplier_stm))
		$Player/Pokemon/fat.text = str(int(pokee.fatigue))
		$Player/Pokemon/element.text = get_eltext(pokee.species.element_type)
	else:
		$Player/Pokemon/nam.text = ""
		$Player/Pokemon/hp.text = ""
		$Player/Pokemon/stm.text = ""
		$Player/Pokemon/fat.text = ""
		$Player/Pokemon/element.text = ""

	if trainer:
		$Player/Player/nam.text = trainer.name
		$Player/Player/hp.text = str(trainer.hp) + "/" + str(trainer.max_hp)
		$Player/Player/stm.text = str(trainer.stamina) + "/" + str(trainer.max_stamina)
		$Player/Player/fat.text = str(int(trainer.fatigue))
	else:
		$Player/Player/nam.text = ""
		$Player/Player/hp.text = ""
		$Player/Player/stm.text = ""
		$Player/Player/fat.text = ""

func upd_move():
	var moves = BattleManager.player_poke.moves

	for i in range(4):
		var btn = $Moves.get_child(i)
		if i < moves.size():
			btn.text = moves[i].name
			btn.disabled = false
			btn.set_meta("move", moves[i])
		else:
			btn.text = "---"
			btn.disabled = true
			btn.set_meta("move", null)

func get_eltext(arr):
	var names = []
	for e in arr:
		names.append(e.display_name)
	return ", ".join(names)

func _on_fight_pressed():
	show_move()

func _on_plr_atk_pressed():
	BattleManager.player_char_use_move(BattleManager.player_char.basic_attack)
	show_Action()

func _on_run_pressed():
	BattleManager.player_try_run()
	show_Action()

func _on_move_pressed(button_path: NodePath):
	var button = get_node(button_path)
	var move_data = button.get_meta("move")
	if move_data:
		BattleManager.player_pokemon_use_move(move_data)
	show_Action()
