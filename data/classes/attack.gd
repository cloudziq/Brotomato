extends    Node2D
class_name attack


export var MELEE := 6.0


onready var mob := get_parent()






func update() -> void:
	MELEE *= mob.scale.x * max(.68, mob.wave_mod * .2)
