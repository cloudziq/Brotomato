extends Area2D


onready var BULLET := preload("res://data/projectiles/standard/Bullet_1_1.tscn")
onready var player := $"../../"


export var AIM_SPEED   := 20
export var SHOOT_DELAY := .1
export var DAMAGE_MOD  := .4
export var SPEED_MOD   := 1.6
export var WALK_MOD    := .2


var timer_diff   := 0.0
var rot_move_mod := 1.0
var enemies		 :  Array
var target_enemy :  int






func _ready() -> void:
	$Timer.wait_time  = SHOOT_DELAY






func _physics_process(delta:float) -> void:
	var speed : float

	change_target()

	if enemies:
		var dest  : Vector2  = enemies[target_enemy].get_node("Sprite").global_position
		var angle : float    = $"%pivot".global_position.direction_to(dest).angle()

		if player.is_moving and timer_diff == 0:
			var wt : float  = $"%Timer".wait_time
			timer_diff      = wt - (wt * WALK_MOD)
			rot_move_mod    = 1
			$"%Timer".wait_time += timer_diff
		elif not player.is_moving and timer_diff > 0:
			rot_move_mod    = (2.2 - WALK_MOD)
			$"%Timer".wait_time -= timer_diff
			timer_diff      = 0

		speed  = rot_move_mod * (AIM_SPEED + (player.SPEED * .1) + (player.level * .6))
		$"%pivot".rotation  = lerp_angle($"%pivot".rotation, angle , speed * (delta * .04))






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
	else:
		$Timer.stop()






func _shoot() -> void:
	var bullet : Area2D = BULLET.instance()
	bullet.global_position  = $"%Muzzle".global_position
	bullet.global_rotation  = $"%Muzzle".global_rotation
	bullet.modulate         = Color(.8, 4, 10, 1)
	bullet.scale           *= .6
	bullet.DAMAGE          += player.ATTACK * DAMAGE_MOD
	bullet.SPEED           *= SPEED_MOD + (player.SPEED * .01)
	bullet.player_target    = target_enemy

	$"%Flash".emitting      = true
	$"/root/SYST/Level/Draw".add_child(bullet)
	$Timer.start()
