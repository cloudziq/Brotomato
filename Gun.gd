extends Area2D


onready var BULLET := preload("res://Bullet.tscn")
onready var player := get_parent()

var look_for_another_target := true
#var last_enemy              := 1
var enemies					:  Array
var target_enemy
#var angle_per_frame         := 0.0


#onready var weapon  = get_parent().get_node("Pistol")






func _physics_process(delta:float) -> void:
	var rot        :  float
	var rot_speed  :  float  = player.SPEED * .06

	if look_for_another_target:
		change_target()

	if enemies:
		var dest : Vector2 = enemies[target_enemy].global_position
		rot  = $"%pivot".global_position.direction_to(dest).angle()
		$"%pivot".rotation  = lerp_angle($"%pivot".rotation, rot , rot_speed * delta)






func change_target() -> void:
	var node    := Sprite
	var closest := 99999999.0
	var dist    :  float
#	var enemy   :  int
	enemies      = get_overlapping_bodies()

	if enemies.size() > 0:
		for i in enemies.size():
			node  = enemies[i].get_node("Sprite")
			dist  = player.global_position.distance_squared_to(enemies[i].global_position)
			if dist < closest:
				closest       = dist
				target_enemy  = i
		if $WeaponTimer.is_stopped():
			_shoot()
			$WeaponTimer.start()
		look_for_another_target  = false
	else:
		$WeaponTimer.stop()







func _shoot() -> void:
	var bullet : Area2D = BULLET.instance()
	bullet.global_position  = $"%Muzzle".global_position
	bullet.global_rotation  = $"%Muzzle".global_rotation
	bullet.DAMAGE          += $"../../Player".ATTACK
	bullet.SPEED           += $"../../Player".SPEED * .1
	$"/root/SYST/Level".add_child(bullet)
	$WeaponTimer.start()
#	last_enemy   = -1
	look_for_another_target  = true
