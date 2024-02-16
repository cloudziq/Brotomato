extends Node2D


var MOB := preload("res://Mob.tscn")

var kill_count       :  int
var time_counter     := 0






func _ready() -> void:
	$"/root/SYST/Level/Draw/Player/HealthBar".value  = 100
	$Sounds/MapMusic.play()
	for i in 10:
		spawn_mob()






func _input(event: InputEvent) -> void:
	if event.is_action("kill_all"):
		get_tree().call_group("Mob", "queue_free")






func spawn_mob() -> void:
	var new_mob              = MOB.instance()
	new_mob.global_position  = new_position()
	$"%Draw".add_child(new_mob)






func new_position() -> Vector2:
	$"%Spawn".unit_offset    = randf()
	return $"%Spawn".global_position






func kill_count_update() -> void:
	kill_count += 1
	$"%KillLabel".text = "KILL COUNT: "+str(kill_count)






func _on_Timer_finish() -> void:
	time_counter += 1
	$"%TimeLabel".text = "TIME: "+str(time_counter)

	if $MobTimer.wait_time > .06:
		var i  = $MobTimer.wait_time - $"../".mob_timer_reduce_per_sec
		if i < .06:
			i  = .06
		$MobTimer.wait_time  = i
		print("Mob Timer: "+str($MobTimer.wait_time))







func _on_MobVisArea_body_exited(_a:RID, body:Node, _c:int, _d:int) -> void:
	if body:
		body.global_position  = new_position()
