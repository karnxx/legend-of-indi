extends Resource
class_name NatureData

enum Stat {
	ATK,
	DEF,
	SPA,
	SPD,
	SPE,
	HP,
	STAMINA
}


@export var inc_stat: Stat
@export var dec_stat: Stat
@export var image : ImageTexture
