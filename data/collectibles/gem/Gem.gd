extends Area2D


onready var gem_collect_sound := $"../Sounds/Collect"
onready var player            := $"../Draw/Player"
onready var attractor         := $"../Draw/Player/Body"


onready var attract_speed_max : int = 200 + player.SPEED
onready var attract_speed     : int = 40 + player.SPEED * .1
var value : int






func _ready() -> void:
	animate()






func _physics_process(delta: float) -> void:
	for area in get_overlapping_areas():
		var dir   = global_position.direction_to(attractor.global_position)
		var dist  = global_position.distance_to(attractor.global_position)
		global_position += dir * attract_speed * delta
		if attract_speed < attract_speed_max:
			attract_speed += 2
		if dist < 10:
			collect(player)






func animate() -> void:
	var tween  = self.create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($sprite, "rotation_degrees", randi()%360, 1)
	tween.tween_callback(self, "animate")






func collect(player:KinematicBody2D) -> void:
	player.experience += value
	player.exp_print()

	gem_collect_sound.stream  = load("res://data/sounds/gem_collect.wav")
	gem_collect_sound.pitch_scale  = 1 + rand_range(-.1, .1)
	gem_collect_sound.play()
	queue_free()
