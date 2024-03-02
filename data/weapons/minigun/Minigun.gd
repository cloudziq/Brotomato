extends Area2D


onready var BULLET := preload("res://data/projectiles/standard/Bullet_1_1.tscn")
onready var player := get_parent()


export var ROT_SPEED   := 40
export var SHOOT_DELAY := .1
export var DAMAGE_MOD  := .6
export var WALK_MOD    := .2


var timer_diff       := 0.0
var ROT_MOD          := 1.0
var enemies		     :  Array
var target_enemy     :  int
var allow_new_target := true






func _ready() -> void:
	$Timer.wait_time  = SHOOT_DELAY







func _physics_process(delta:float) -> void:
	if allow_new_target:
		change_target()

	if enemies and target_enemy < enemies.size():
		var dest       :  Vector2  = enemies[target_enemy].global_position
		var dir        :  Vector2  = $"%pivot".global_position - dest
		var angle      := polar2cartesian(1.0, $"%pivot".rotation)
		var difference := dir.angle() - angle.angle()
		var dot        := getDot(dir, angle)

		if player.is_moving and timer_diff == 0:
			var wt : float  = $"%Timer".wait_time
			timer_diff      = wt - (wt * WALK_MOD)
			ROT_MOD         = 1
			$"%Timer".wait_time += timer_diff
		elif not player.is_moving and timer_diff > 0:
			ROT_MOD         = (2 - WALK_MOD)
			$"%Timer".wait_time -= timer_diff
			timer_diff  = 0

		if abs(difference) > 0.1:
			var sum  : float  = ROT_MOD * (ROT_SPEED + (player.SPEED * player.level * .1))
			$"%pivot".rotation += sign(dot)*deg2rad(sum)*delta






func change_target() -> void:
	var node    := Sprite
	var closest := 999999.0
	var dist    :  float
	enemies      = get_overlapping_bodies()

	if enemies.size() > 0:
		for i in enemies.size():
			node  = enemies[i].get_node("Sprite")
			dist  = player.global_position.distance_squared_to(node.global_position)
			if dist < closest:
				closest       = dist
				target_enemy  = i
		if $Timer.is_stopped():
			$Timer.start()

			allow_new_target  = false
	else:
		$Timer.stop()






func getDot(v1:Vector2, v2:Vector2) -> float:
	var n1   = v1.normalized()
	var n2   = v2.normalized()
	var Dot  = n1.dot(n2.tangent())

	return Dot






func _shoot() -> void:
	var bullet : Area2D = BULLET.instance()
	bullet.global_position  = $"%Muzzle".global_position
	bullet.global_rotation  = $"%Muzzle".global_rotation
	bullet.modulate         = Color(.8, 4, 10, 1)
	bullet.scale           *= .6
	bullet.DAMAGE          += player.ATTACK
	bullet.SPEED           += player.SPEED * .1
	bullet.player_weapon    = self

	allow_new_target        = true
	$"%Flash".emitting      = true

	$"/root/SYST/Level/Draw".add_child(bullet)
	$Timer.start()
