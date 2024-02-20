extends Area2D


onready var gem_collect_sound := $"../Sounds/Collect"
onready var player            := $"../Draw/Player"
onready var attractor         := $"../Draw/Player/Body"


onready var attract_speed_max := 999.0
onready var attract_speed     := .4 * float(player.INT + player.level * 1.6)


onready var attract_speed_def := attract_speed


var value : int






func _ready() -> void:
	animate()






func _physics_process(delta: float) -> void:
	for area in get_overlapping_areas():
		var dir   := global_position.direction_to(attractor.global_position)
		var dist  := global_position.distance_to(attractor.global_position)

		global_position += dir * attract_speed * delta

		if attract_speed < attract_speed_max:
			attract_speed += player.level * .04 * delta
		if dist <= 28:
			collect()






func animate() -> void:
	var tween  = self.create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Sprite, "rotation_degrees", randi()%360, 1)
	tween.tween_callback(self, "animate")






func collect() -> void:
	player.experience += value

	$Particles.emitting  = true

	gem_collect_sound.stream  = load("res://data/sounds/gem_collect.wav")
	gem_collect_sound.pitch_scale  = 1 + rand_range(-.1, .1)
	gem_collect_sound.play()
	set_collision_mask_bit(0, false)
	$Sprite.modulate  =lerp(Color(1,1,1,1), Color(1,1,1,0), 1)
	yield(get_tree().create_timer(1.1), "timeout")
	queue_free()






func _on_player_exit(_a:RID, _b:Area2D, _c:int, _d:int) -> void:
	attract_speed  = attract_speed_def
