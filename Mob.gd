extends KinematicBody2D


export var HEALTH   := 20.0
export var SPEED    := 88.0
export var STAMINA  := 4.0
export var MELEE    := 6.0
export var DROPRATE := 40
export var EXP      := 50


onready var player      = get_node("../Player")
onready var level       = get_node("../../../Level")
onready var hurt_sound := $"/root/SYST/Level/Sounds/EnemyHurt"


var velocity     :  Vector2
var direction    :  Vector2






func _ready() -> void:
	SPEED  += rand_range(-20, 20)
	scale  *= rand_range(.94, 1.06)
	$Body.self_modulate.r *= rand_range(.92, 1)
	$Body.self_modulate.g *= rand_range(.80, 1)
	$AnimPlayer.play("move")





func _physics_process(_delta:float) -> void:
	direction  = global_position.direction_to(player.global_position)
	velocity   = direction * SPEED
	velocity   = move_and_slide(velocity)






func take_damage(damage:int, is_melee:=false) -> void:
	HEALTH -= damage

	if HEALTH > 0:
		if is_melee:
			hurt_sound.stream       = load("res://data/sounds/melee.wav")
			hurt_sound.pitch_scale  = 1 - rand_range(.5, .6)
		else:
			hurt_sound.pitch_scale  = rand_range(2, 3)
		hurt_sound.play()
	else:
		kill(is_melee)






func kill(is_melee:=false) -> void:
	hurt_sound.stream       = load("res://data/sounds/squeak_small.wav")
	hurt_sound.pitch_scale  = 1 + rand_range(-.1, .1)

	$"../../".kill_count_update()
	hurt_sound.play()

	#calculate loot?
	if rand_range(0, 100) >= 100-DROPRATE:
		var GEM  = preload("res://data/collectibles/gem/Gem.tscn").instance()
		GEM.global_position  = global_position
		GEM.value  = EXP
		level.call_deferred("add_child", GEM)

	set_physics_process(false)
	set_collision_layer_bit(4, false)
	$AnimPlayer.play("stun_in")
	yield(get_tree().create_timer(.4), "timeout")
	remove()






func pushback(stun:=false) -> void:
	global_position += -direction * MELEE * 1.6
	if stun:
		set_physics_process(false)
		$AnimPlayer.play("stun_in")
		var t  = self.create_tween()
		t.tween_callback(self, "pushback_end").set_delay(1 - (STAMINA * .04))


func pushback_end() -> void:
	if HEALTH > 0:
		set_physics_process(true)
		$AnimPlayer.play("stun_out")
		$AnimPlayer.queue("move")





func remove() -> void:
	var tween  = get_tree().create_tween().set_parallel()
	tween.tween_property($Body, "modulate", Color(1,1,1,0), 1)
	tween.tween_property($Body, "scale", Vector2(0,0), 1.2)
	tween.chain().tween_callback(self, "queue_free")
