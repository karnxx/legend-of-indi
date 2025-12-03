extends Resource
class_name ReversalData
enum ElementType { NORMAL, FIRE, WATER, GRASS }
@export var new_element_type: ElementType

@export var stat_mult := {
	"hp":1.0, "atk":1.0, "def":1.0, "spa":1.0, "spd":1.0, "spe":1.0
}
