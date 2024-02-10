extends Node2D


var MOB : PackedScene = preload("res://Mob.tscn")

var kill_count : int






func _ready() -> void:
	$"/root/SYST/Level/Draw/Player/HealthBar".value  = 100




func _input(event: InputEvent) -> void:
	if  event.is_action("kill_all"):
		get_tree().call_group("Mob", "queue_free")



func spawn_mob() -> void:
	var new_mob              = MOB.instance()
	$"%Spawn".unit_offset    = randf()
	new_mob.global_position  = $"%Spawn".global_position
	$"%Draw".add_child(new_mob)


func kill_count_update() -> void:
	kill_count += 1
	$"%Label".text = "KILL COUNT: "+str(kill_count)
