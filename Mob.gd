extends KinematicBody2D


export var HEALTH   := 20.0
export var SPEED    := 88
export var STAMINA  := 4
export var MELEE    := 6
export var DROPRATE := 32
export var EXP      := 1


onready var player   = get_node("../Player")
onready var level    = get_node("../../../Level/Draw")


var velocity  : Vector2
var direction : Vector2






func _ready() -> void:
	SPEED  += int(rand_range(-20, 20))
	$AnimPlayer.play("move")





func _physics_process(_delta:float) -> void:
	direction  = global_position.direction_to(player.global_position)
	velocity  = direction * SPEED
	velocity  = move_and_slide(velocity)






func take_damage(damage:int) -> void:
	HEALTH -= damage
	if HEALTH <= 0:
		var node         := $"/root/SYST/Level/Sounds/EnemyDeath"
		var path          = "res://data/sounds/squeak_small.wav"
		node.stream       = load(path)
		node.pitch_scale  = 1 + rand_range(-.1, .1)
		node.play()
		$"../../".kill_count_update()

		#calculate loot?
		if rand_range(0, 100) >= 100-DROPRATE:
			var GEM  = preload("res://Gem.tscn").instance()
			GEM.global_position  = global_position
			GEM.value  = EXP

			level.add_child(GEM)
			yield(get_tree().create_timer(.1), "timeout")
		queue_free()






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
