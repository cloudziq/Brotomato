extends Area2D


var BULLET = preload("res://Bullet.tscn")





func _physics_process(_delta:float) -> void:
	var enemies  = get_overlapping_bodies()

	if enemies.size() > 0:
		var target = enemies.front()
		$"%Pistol".look_at(target.global_position)
		if $WeaponTimer.is_stopped():
			shoot()
			$WeaponTimer.start(-1)
	else:
		$WeaponTimer.stop()





func shoot() -> void:
	var bullet = BULLET.instance()
	bullet.global_position  = $"%Muzzle".global_position
	bullet.global_rotation  = $"%Muzzle".global_rotation
	$"/root/SYST/Level".add_child(bullet)







func _shoot_delay_end() -> void:
	shoot()
