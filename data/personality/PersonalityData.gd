extends Resource
class_name PersonalityData
enum Mood {
	CALM,
	AGGRESSIVE,
	PLAYFUL,
	ANXIOUS,
	LAZY
}

enum WildBehavior {
	FLEE,
	FIGHT,
	CURIOUS,
	PACK_HUNTER,
	TERRITORIAL
}

enum Stat {
	ATK,
	DEF,
	SPA,
	SPD,
	SPE,
	HP,
	STAMINA
}
@export var display_name: String

@export var mood_bias: Dictionary = {
	"calm": 0.0,
	"aggressive": 0.0,
	"playful": 0.0,
	"anxious": 0.0,
	"lazy": 0.0,
}

@export var loyalty_base: int 

@export var wild_behavior: WildBehavior 

@export var inc_stat: Stat 
@export var dec_stat: Stat 

@export var description: String = ""

@export var personality_script : Script
@export var image : ImageTexture
