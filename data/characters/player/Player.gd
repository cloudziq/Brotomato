extends KinematicBody2D


export var HEALTH  := 100.0
export var SPEED   := 220.0
export var ATTACK  := 2.0
export var STAMINA := 8.0
export var MELEE   := 12.0
export var INT     := 10.0
export var LUCK    := 4.0




signal health_depleted


var velocity   := Vector2.ZERO
var level      := 0
var experience := 0.0
var exp_needed := 4


onready var level_up_sound := $"../../Sounds/LevelUp"
onready var melee_sound    := $"../../Sounds/Melee"






func _ready() -> void:
	level_up()
	play_idle_animation()






func _physics_process(delta: float) -> void:
	var direction  = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity       = direction * SPEED
	velocity       = move_and_slide(velocity)

	for body in $"%HurtArea".get_overlapping_bodies():
		melee_action(body, delta)

	if experience >= exp_needed:
		level_up()






func melee_action(body:Node2D, delta:float) -> void:
		HEALTH -= max(0.2, body.MELEE / STAMINA * delta * 100)
		body.take_damage(max(0.2, (MELEE / body.STAMINA) * delta * 100), true)
		body.pushback(true)

		level_up_sound.stream  = load("res://data/sounds/melee.wav")
		level_up_sound.pitch_scale  = 1 + rand_range(-.1, .1)
		level_up_sound.play()

		if HEALTH <= 0:
			HEALTH = 100
			$"%HealthBar".value  = HEALTH
			emit_signal("health_depleted")
		$"%HealthBar".value  = HEALTH






func level_up(a:=0.0) -> void:
	if level != 0:
		a    = INT * .1
		exp_needed += (4 * level) + 2

		HEALTH  += a
		SPEED   += a * .018
		ATTACK  += a
		STAMINA += a
		MELEE   += a
		INT     += a * .104
		LUCK    += a

		var path     = "res://data/sounds/level_up.wav"
		level_up_sound.stream  = load(path)
		level_up_sound.pitch_scale  = 1 + rand_range(-.1, .1)
		level_up_sound.play()

	level += 1
	exp_print(true, a)






func exp_print(lv:=false, add:=0.0) -> void:
	if lv:
		print("               CURRENT LEVEL: "+str(level))
		print("               add_value    : "+str(add))
		print("HEALTH: "+str(HEALTH))
		print("SPEED: "+str(SPEED))
		print("ATTACK: "+str(ATTACK))
		print("STAMINA: "+str(STAMINA))
		print("MELEE: "+str(MELEE))
		print("INT: "+str(INT))
		print("LUCK: "+str(LUCK))

	print("exp: "+str(experience)+"/"+str(exp_needed))






func play_idle_animation() -> void:
	$"%AnimPlayer".play("idle")


func play_walk_animation() -> void:
	$"%AnimPlayer".play("walk")
