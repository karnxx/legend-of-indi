extends Node

func _ready():
	await get_tree().create_timer(1).timeout
	var player_poke = MonGenerator.generate(GameData.species[0], 10)
	var enemy_poke = MonGenerator.generate(GameData.species[0], 8)

	var player := PlayerData
	player.hp = 100
	player.max_hp = 100
	player.stamina = 100
	player.max_stamina = 100
	player.fatigue = 0
	player.name = "You"

	var enemy_trainer := Trainer.new()
	enemy_trainer.name = "Enemy Trainer"
	enemy_trainer.hp = 100
	enemy_trainer.max_hp = 100
	enemy_trainer.stamina = 100
	enemy_trainer.max_stamina = 100
	enemy_trainer.fatigue = 0

	BattleManager.start_trainer_battle(
		player,
		player_poke,
		enemy_trainer,
		enemy_poke
	)
