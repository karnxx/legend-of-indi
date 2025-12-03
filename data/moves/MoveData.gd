extends Resource
class_name MoveData

@export var name: String
@export var element: Array[ElementData]
@export var power: int
@export var accuracy: int
@export var stamina_cost: int
@export var image : ImageTexture

@export_enum("ranged", 'physical', 'buff', 'debuff', 'special') var category
@export var status_effects: Array[StatusEffect]
@export var status_chance : float
