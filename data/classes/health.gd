extends    Node2D
class_name health


export var HEALTH    := 10.0
export var STAMINA   := 4.0


onready var hurt_sound  := $"/root/SYST/Level/Sounds/EnemyHurt"
onready var mob         := get_parent()






func update() -> void:
	HEALTH  += mob.scale.x * max(.68, mob.wave_mod * .1)
	STAMINA += mob.scale.x * max(.68, mob.wave_mod * .1)






func take_damage(damage:int, is_melee:=false) -> void:
	HEALTH -= damage

	if HEALTH > 0:
		hurt_sound.stream  = load("res://data/sounds/melee.wav")
		if is_melee:
			hurt_sound.pitch_scale  = 1 - rand_range(.5, .6)
		else:
			hurt_sound.pitch_scale  = rand_range(2, 3)
		hurt_sound.play()
	else:
		kill()






func kill() -> void:
	hurt_sound.stream       = load("res://data/sounds/squeak_small.wav")
	hurt_sound.pitch_scale  = .4 + rand_range(-.1, .1)

	$"../../../".kill_count_update()
	hurt_sound.play()

	var drop := get_parent().get_node("drop")
	if drop and rand_range(0, 100) >= 100-drop.DROPRATE:
		drop.loot()

	if get_parent().has_node("move"):
		$"../move".set_physics_process(false)

	get_parent().set_collision_layer_bit(4, false)
	$"%AnimPlayer".play("death")
	yield(create_tween().tween_interval(.4), "finished")
	get_parent().remove()
