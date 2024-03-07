extends    Node2D
class_name mob_move


export var MOVE_SPEED := 20.0


onready var player := $"/root/SYST/Level/Draw/Player"
onready var mob    := get_parent()


var velocity  : Vector2
var direction : Vector2






func update() -> void:
	print(mob.wave_mod)
	MOVE_SPEED  *= rand_range(.92, 1.08) * mob.scale.x * max(1.46, .68 * mob.wave_mod)
	mob.get_node("AnimPlayer").play("move", -1, .06 * MOVE_SPEED)






func _physics_process(_delta:float):
	direction  = global_position.direction_to(player.global_position)
	velocity   = direction * MOVE_SPEED
	velocity   = mob.move_and_slide(velocity)
