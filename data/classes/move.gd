extends    Node2D
class_name mob_move


export var MOVE_SPEED := 1.0


onready var player  := $"/root/SYST/Level/Draw/Player"
onready var mob     := get_parent()


var velocity  :  Vector2
var direction :  Vector2






func _ready() -> void:
	MOVE_SPEED  += rand_range(-20, 20)






func _physics_process(_delta:float):
	direction  = global_position.direction_to(player.global_position)
	velocity   = direction * MOVE_SPEED
	velocity   = mob.move_and_slide(velocity)
