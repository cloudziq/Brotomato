extends KinematicBody2D


export var SPEED   := 260
export var HEALTH  := 100
export var STAMINA := 20


signal player_death


var velocity : Vector2






func _ready() -> void:
	play_idle_animation()






func _physics_process(delta: float) -> void:
	var direction  = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity       = direction * SPEED
	velocity       = move_and_slide(velocity)
	$body/torso/face.rotation_degrees += delta

	for body in $"%hurtbox".get_overlapping_bodies():
		HEALTH -= body.MELEE * delta
		player_death.emit()
		print(HEALTH)






func play_idle_animation():
	$"%AnimPlayer".play("idle")


func play_walk_animation():
	$"%AnimPlayer".play("walk")
