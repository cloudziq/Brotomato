extends    Node2D
class_name drop


onready var level := get_node("../../../../Level/Draw")


export var DROPRATE  := 50
export var EXP       := 1






func loot() -> void:
	var GEM              = preload("res://data/collectibles/orb/Orb.tscn").instance()
	GEM.global_position  = global_position
	GEM.value            = $"../drop".EXP
	level.call_deferred("add_child", GEM)
