extends Resource
class_name ElementData

@export var display_name: String
@export var color: Color
@export var picture:ImageTexture

@export var strong_against: Array[ElementData]
@export var weak_against: Array[ElementData]
@export var resists: Array[ElementData]
@export var immune_to: Array[ElementData]

@export var tags: Array[String]
