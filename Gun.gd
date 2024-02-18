extends Area2D


onready var BULLET  = preload("res://Bullet.tscn")
onready var player  = get_parent()
#onready var weapon  = get_parent().get_node("Pistol")





func _physics_process(delta:float) -> void:
	var enemies    := get_overlapping_bodies()
	var closest    := 99999999.0
	var dist       :  float
	var enemy      :  int
	var rot        :  float
	var rot_speed  :  float  = player.SPEED * .02

	if enemies.size() > 0:
		for i in enemies.size():
			dist  = player.global_position.distance_squared_to(enemies[i].global_position)
			if dist < closest:
				closest  = dist
				enemy    = i
		rot  = $"%pivot".global_position.direction_to(enemies[enemy].global_position).angle()
		$"%pivot".rotation  = lerp_angle($"%pivot".rotation, rot , rot_speed * delta)
		#### activate a weapon:
		if $WeaponTimer.is_stopped():
			$WeaponTimer.start(-1)
#			shoot()
	else:
		$WeaponTimer.stop()





func shoot() -> void:
	var bullet : Area2D = BULLET.instance()
	bullet.global_position  = $"%Muzzle".global_position
	bullet.global_rotation  = $"%Muzzle".global_rotation
	bullet.DAMAGE          += $"../../Player".ATTACK
	bullet.SPEED           += $"../../Player".SPEED * .1
	$"/root/SYST/Level".add_child(bullet)






func _shoot_delay_end() -> void:
	shoot()
