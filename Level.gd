extends Node2D


var kill_count   :  int
var time_counter := 0
var current_mob  := 0


onready var MOB  := preload("res://data/characters/mobs/Slime/Slime.tscn")


var mob_data := [
	["Green Slime", "Slime", Color(0,1,0,1), 0],
	["Red Slime"  , "Slime", Color(1,0,0,1), 20]
]






func _ready() -> void:
	$"/root/SYST/Level/Draw/Player/HealthBar".value  = 100
#	$Sounds/MapMusic.play()
	for i in 2:
		yield(get_tree().create_timer(0.06 * i), "timeout")
		spawn_mob()






func _input(event: InputEvent) -> void:
	if event.is_action_pressed("kill_all"):
		$MobTimer.wait_time *= 1.5

		for n in get_tree().get_nodes_in_group("Mob"):
			n.get_node("health").kill()
			kill_count += 1






func spawn_mob() -> void:
	if current_mob < mob_data.size()-1:
		var val : float  = get_parent().game_duration * (mob_data[current_mob+1][3] * .01)
		if time_counter > val:
			current_mob += 1

	var new_mob              = MOB .instance()
	new_mob.global_position  = new_position()
	new_mob.modulate         = Color(mob_data[current_mob][2])
	$"%Draw".add_child(new_mob)






func new_position() -> Vector2:
	$"%Spawn".unit_offset    = randf()
	return $"%Spawn".global_position






func kill_count_update() -> void:
	kill_count += 1
	$"%KillLabel".text = "KILL COUNT: "+str(kill_count)






func _on_GeneralTimer_finish() -> void:
	time_counter += 1
	$"%TimeLabel".text = "TIME: "+str(time_counter)

	if $MobTimer.wait_time > .06:
		var i  = $MobTimer.wait_time - get_parent().mob_timer_reduce_per_sec
		if i < .06:
			i  = .06
		$MobTimer.wait_time  = i
		print("Mob Timer: "+str($MobTimer.wait_time))







func _on_MobVisArea_body_exited(_a:RID, body:KinematicBody2D, _c:int, _d:int) -> void:
	if body and body.get_collision_layer_bit(4):
		body.global_position  = new_position()
