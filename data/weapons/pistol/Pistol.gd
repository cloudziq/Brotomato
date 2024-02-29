extends Area2D


onready var BULLET := preload("res://data/projectiles/standard/Bullet_1_1.tscn")
onready var player := get_parent()


export var ROT_SPEED   := 80
export var SHOOT_DELAY := 1


var allow_new_target := true
var enemies		     :  Array
var target_enemy     :  int






func _ready() -> void:
	$Timer.wait_time  = SHOOT_DELAY






func _physics_process(delta:float) -> void:
	if allow_new_target:
		change_target()

	if enemies:
		var dest       :  Vector2  = enemies[target_enemy].global_position
		var dir        :  Vector2  = $"%pivot".global_position - dest
		var angle      := polar2cartesian(1.0, $"%pivot".rotation)
		var difference := dir.angle() - angle.angle()
		var dot        := getDot(dir, angle)

		if abs(difference) > 0.1:
			$"%pivot".rotation += sign(dot) * deg2rad(ROT_SPEED) * delta






func change_target() -> void:
	var node    := Sprite
	var closest := 99999999.0
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
	bullet.DAMAGE          += $"../../Player".ATTACK
	bullet.SPEED           += $"../../Player".SPEED * .1
	$"/root/SYST/Level".add_child(bullet)
	$Timer.start()
	$"%Flash".emitting  = true
	allow_new_target    = true
