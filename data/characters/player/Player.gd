extends    KinematicBody2D
class_name Player


#  starting stats (1-100)
export var HEALTH  := 100.0
export var SPEED   := 22.0
export var ATTACK  := 2.0
export var STAMINA := 8.0
export var MELEE   := 4.0
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
	velocity       = direction * SPEED * 10
	velocity       = move_and_slide(velocity)

	for body in $"%HurtArea".get_overlapping_bodies():
		melee_action(body, delta)

	if experience >= exp_needed:
		level_up()






func melee_action(body:Node2D, delta:float) -> void:
		HEALTH -= max(0.2, body.MELEE / STAMINA * delta * 100)

		melee_sound.stream  = load("res://data/sounds/melee.wav")
		melee_sound.pitch_scale  = 1 + rand_range(-.1, .1)
		melee_sound.play()

		if HEALTH <= 0:
			HEALTH = 100
			$"%HealthBar".value  = HEALTH
			emit_signal("health_depleted")
		$"%HealthBar".value  = HEALTH

		if body.has_node("damage"):
			var node   := body.get_node("damage")
			var damage := max(0.2, (MELEE / node.STAMINA) * delta * 100)
			node.take_damage(damage, true)
		body.pushback(true, MELEE)






func level_up(a:=0.0) -> void:
	if level != 0:
		a    = INT * .1
		exp_needed += (4 * level) + 2

		HEALTH  += a * .202
		SPEED   += a * .036
		ATTACK  += a * .420
		STAMINA += a * .400
		MELEE   += a * .320
		INT     += a * .104
		LUCK    += a * .020

		var node  := $Gun/WeaponTimer
		if node.wait_time > 0.06:
			node.wait_time -= SPEED * 0.0001

		$CollectArea/CollectCollider.shape.radius += a * 0.64

		var path     = "res://data/sounds/level_up.wav"
		level_up_sound.stream  = load(path)
		level_up_sound.pitch_scale  = 1 + rand_range(-.1, .1)
		level_up_sound.play()

	level += 1
	$"../../UI/LevelLabel".text  = "LEVEL: "+str(level)






func play_idle_animation() -> void:
	$"%AnimPlayer".play("idle")


func play_walk_animation() -> void:
	$"%AnimPlayer".play("walk")
