extends Resource
class_name ElementData

enum ElementType { NORMAL, FIRE, WATER, GRASS }

@export var element_type: ElementType
@export var display_name: String
@export var color: Color
@export var picture: ImageTexture

@export var strong_against: Array[ElementType] = []
@export var weak_against: Array[ElementType] = []
@export var resists: Array[ElementType] = []
@export var immune_to: Array[ElementType] = []

@export var tags: Array[String] = []
