extends Resource
class_name ElementData

# Define your elements as an enum
enum ElementType { NORMAL, FIRE, WATER, GRASS }

@export var element_type: ElementType  # unique type for this element
@export var display_name: String
@export var color: Color
@export var picture: ImageTexture

# Use enums for relationships instead of cross-referencing ElementData resources
@export var strong_against: Array[ElementType] = []
@export var weak_against: Array[ElementType] = []
@export var resists: Array[ElementType] = []
@export var immune_to: Array[ElementType] = []

@export var tags: Array[String] = []
