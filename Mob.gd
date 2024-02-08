extends KinematicBody2D


export var SPEED   := 80
export var HEALTH  := 10
export var MELEE   := 1


onready var player = get_node("../../Player")
var velocity : Vector2






func _ready() -> void:
	SPEED  += int(rand_range(-20, 20))






func _physics_process(_delta:float) -> void:
	var direction  = global_position.direction_to(player.global_position)
	velocity  = direction * SPEED
	velocity  = move_and_slide(velocity)






func take_damage(damage:int) -> void:
	HEALTH -= damage
	if HEALTH <= 0:
		queue_free()
