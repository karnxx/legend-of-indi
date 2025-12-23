extends Node

func _ready():
	await get_tree().create_timer(1).timeout
	var player_poke = MonGenerator.generate(GameData.species[0], 10)
	var enemy_poke = MonGenerator.generate(GameData.species[0], 8)

	var player := PlayerData
	player.current_hp = 100
	player.max_hp = 100
	player.stamina = 100
	player.max_stamina = 100
	player.fatigue = 0
	player.name = "You"
	player.stats = {
	"hp":1.0, "atk":1.0, "def":1.0, "spa":1.0, "spd":1.0, "spe":1.2
	}

	var enemy_trainer := Trainer.new()
	enemy_trainer.name = "Enemy Trainer"
	enemy_trainer.current_hp = 100
	enemy_trainer.max_hp = 100
	enemy_trainer.stamina = 100
	enemy_trainer.max_stamina = 100
	enemy_trainer.fatigue = 0
	enemy_trainer.stats = {
	"hp":1.0, "atk":1.0, "def":1.0, "spa":1.0, "spd":1.0, "spe":0.8
	}

	BattleManager.start_trainer_battle(
		player,
		player_poke,
		enemy_trainer,
		enemy_poke
	)
