extends Node2D


onready var gem_collect_sound := $"../../Sounds/Collect"
onready var player            := $"../Player"
onready var attractor         := $"../Player/Body"


onready var attract_speed_max := 2222.0
onready var attract_speed     := 0.0


onready var attract_speed_def := attract_speed


var value      :  int
var wiggle_mod := 1.0






func _ready() -> void:
	var s  := rand_range(-.04, .04)
	scale  = Vector2(.44+s, .44+s)
	animate()
	anim_pos()






func _physics_process(delta: float) -> void:
	for area in $"%TouchArea".get_overlapping_areas():
		var dir   := global_position.direction_to(attractor.global_position)
		var dist  := global_position.distance_to(attractor.global_position)

		global_position += dir * attract_speed * delta

		if attract_speed < attract_speed_max:
			attract_speed += player.level * .004 * delta

		if dist < 25:
			collect()

	wiggle_mod  = .48 if $"%TouchArea".get_overlapping_areas().size() > 0 else 1.0






func animate() -> void:
	if not is_queued_for_deletion():
		var tween := self.create_tween().set_ease(2).set_trans(1)
		tween.tween_property($"%Sprite", "rotation_degrees", randi()%360, 1)
		tween.tween_callback(self, "animate")






func anim_pos() -> void:
	var mod   :  float  = (wiggle_mod * .06) if wiggle_mod > 1 else 1.0
	var dist  := 44 * wiggle_mod
	var x     := rand_range(-dist, dist)
	var y     := rand_range(-dist, dist)
	var pos   := Vector2(x, y)

	if not is_queued_for_deletion():
		var tween := self.create_tween().set_ease(3).set_trans(1)
		tween.tween_property($"%Sprite", "position", pos, rand_range(.4, .8) * mod)
		tween.tween_callback(self, "anim_pos")






func collect() -> void:
	player.experience         += value
	$"%Sprite".modulate        = Color(1,1,1,0)
	$"../../UI/ExpLabel".text  = "EXP: "+str(player.experience)+" / "+str(player.exp_needed)

	gem_collect_sound.stream  = load("res://data/sounds/gem_collect.wav")
	gem_collect_sound.pitch_scale  = 1 + rand_range(-.1, .1)
	gem_collect_sound.play()

	queue_free()






func _on_player_enter(_a:RID, _b:Area2D, _c:int, _d:int) -> void:
	attract_speed  = .52 * (player.INT + player.level)
