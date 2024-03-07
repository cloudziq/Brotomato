extends Area2D


onready var BULLET := preload("res://data/projectiles/standard/Bullet_1_1.tscn")
onready var player := $"../../"


export var AIM_SPEED   := 200
export var SHOOT_DELAY := 1
export var SPEED_MOD   := .96


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

		speed  = rot_move_mod * (AIM_SPEED + (player.SPEED * .1) + (player.level * .6))
		$"%pivot".rotation  = lerp_angle($"%pivot".rotation, angle , speed * delta * .04)






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
	bullet.DAMAGE          += player.ATTACK
	bullet.SPEED           += player.SPEED * .1
	bullet.player_target    = target_enemy

	$"%Flash".emitting      = true
	$"/root/SYST/Level/Draw".add_child(bullet)
	$Timer.start()
