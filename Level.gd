extends Node2D


var kill_count    :  int
var time_counter  := 0

var current_mob   := 0    #  var to control mob amounts of each wave
var mobs_to_spawn := 0
onready var mob_type     := 0    #  current mob 'wave'
onready var mob_wave_mod := 1

var mob_data := [
	["Green Slime",  "Slime", Color(  0,   1,    0,  1), 0],
	["Yellow Slime", "Slime", Color(  1,  .8,    0,  1), 20],
	["Red Slime",    "Slime", Color(  1,   0,    0,  1), 48],
	["Purple Slime", "Slime", Color(  1, .26,  .86,  1), 72],
	["Black Slime",  "Slime", Color(.22, .22,  .22,  1), 90]
]


onready var MOB  := preload("res://data/characters/mobs/Slime/Slime.tscn")






func _ready() -> void:
	$"/root/SYST/Level/Draw/Player/HealthBar".value  = 100
	$Sounds/MapMusic.play()
	for i in 20:
		yield(get_tree().create_timer(0.08 * i), "timeout")
		if is_queued_for_deletion():
			return
		else:
			spawn_mob()

	mobs_to_spawn  = int(pow(mob_data.size(), 2) / mob_data.size()-1)






func _input(event: InputEvent) -> void:
	if event.is_action_pressed("kill_all"):
		if $MobTimer.wait_time >= 0.08:
			$MobTimer.wait_time *= 1.5
			print($MobTimer.wait_time)

		for n in get_tree().get_nodes_in_group("Mob"):
			n.get_node("health").kill()
			kill_count += 1

		for n in get_tree().get_nodes_in_group("orb"):
			n.queue_free()






func spawn_mob() ->  void:
	if G.active_mob_count < 220:
		change_mob()

		var new_mob              = MOB.instance()
		new_mob.global_position  = new_position()

		var val : int
		if mob_wave_mod > 0 and rand_range(0,100) > 80:
			val  = int(rand_range(0, mob_data.size()-1))
		else:
			val  = 0

		new_mob.modulate         = Color(mob_data[val][2])
		$"%Draw".add_child(new_mob)






func change_mob() ->  void:
	var mob_data_size  = mob_data.size()
	var val : float    = get_parent().game_duration * (mob_data[mob_type][3] * .01)

	if current_mob == mobs_to_spawn:
		if time_counter > val:
			if mob_type == mob_data_size-1:
				mob_type       = 0
				mob_wave_mod += 1
				mobs_to_spawn  = int(pow(mob_type+1, 2) / int(mob_type+1))
			else:
				mob_type      += 1
				mobs_to_spawn *= int(2 * max(1, mob_wave_mod * .6))
				current_mob  = 0

				for i in get_tree().get_nodes_in_group("exp_drop"):
					i.update()
	else:
		current_mob += 1






func new_position() -> Vector2:
	$"%Spawn".unit_offset  = randf()
	var direction  = $"%Spawn".global_position.direction_to($"%Player".global_position)
	return $"%Spawn".global_position + direction * rand_range(1, 60)






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
#		print("Mob Timer: "+str($MobTimer.wait_time))







func _on_MobVisArea_body_exited(_a:RID, body:KinematicBody2D, _c:int, _d:int) -> void:
	if body and body.get_collision_layer_bit(4):
		body.global_position  = new_position()
