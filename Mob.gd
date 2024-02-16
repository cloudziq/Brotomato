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


var velocity  : Vector2
var direction : Vector2






func _ready() -> void:
	SPEED  += rand_range(-20, 20)
	scale  *= rand_range(.94, 1.06)
	$AnimPlayer.play("move")





func _physics_process(_delta:float) -> void:
	direction  = global_position.direction_to(player.global_position)
	velocity  = direction * SPEED
	velocity  = move_and_slide(velocity)






func take_damage(damage:int, is_melee:=false) -> void:
	HEALTH -= damage
	if HEALTH <= 0:

		hurt_sound.stream       = load("res://data/sounds/squeak_small.wav")
		hurt_sound.pitch_scale  = 1 + rand_range(-.1, .1)

		$"../../".kill_count_update()

		#calculate loot?
		if rand_range(0, 100) >= 100-DROPRATE:
			var GEM  = preload("res://Gem.tscn").instance()
			GEM.global_position  = global_position
			GEM.value  = EXP
			level.call_deferred("add_child", GEM)
		queue_free()
	else:
		if is_melee:
			hurt_sound.pitch_scale  = 1 - rand_range(.5, .6)
		else:
			hurt_sound.pitch_scale  = rand_range(2, 3)

		hurt_sound.stream  = load("res://data/sounds/melee.wav")

	hurt_sound.play()





func pushback(stun:=false) -> void:
	global_position += -direction * MELEE * 1.6
	if stun:
		set_physics_process(false)
		$AnimPlayer.play("stun_in")
		var t  = self.create_tween()
		t.tween_callback(self, "pushback_end").set_delay(1 - (STAMINA * .04))



func pushback_end() -> void:
	set_physics_process(true)
	$AnimPlayer.play("stun_out")
	$AnimPlayer.queue("move")
