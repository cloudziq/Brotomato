extends KinematicBody2D


onready var player = get_node("../Player")
onready var tween  : SceneTreeTween


var player_weapon : Area2D






func _ready() -> void:
	scale  *= rand_range(.94, 1.06)
	$Sprite.self_modulate.r *= rand_range(.9, 1)
	$Sprite.self_modulate.g *= rand_range(.9, 1)
	$Sprite.self_modulate.b *= rand_range(.9, 1)
	$AnimPlayer.play("move")






func pushback(stun:=false, strength:=0.0) -> void:
	var time  : float
	var trans : int

	if strength > 0:
		time   = .6
		trans  = 0
	else:
		time   = .2
		trans  = 1

	if strength == 0:  strength  = 1
	strength *= 2 if has_node("health") and $health.HEALTH > 0 else 4

	tween  = get_tree().create_tween().set_trans(trans)
	tween.tween_property(self, "global_position",
		global_position + -$move.direction * strength, time)

	if stun:
		var delay : float = player.MELEE * ($health.STAMINA * .008)
		$move.set_physics_process(false)
		tween.tween_callback(self, "pushback_end").set_delay(delay)






func pushback_end() -> void:
	if has_node("health") and $health.HEALTH > 0:
		$move.set_physics_process(true)
		$AnimPlayer.play("move")






func remove() -> void:
	if player_weapon:
		player_weapon.allow_new_target  = true

	tween  = get_tree().create_tween()
	tween.set_parallel().set_trans(1).set_ease(Tween.EASE_IN)
	tween.tween_property($Sprite, "modulate", Color(1,1,1,0), 1)
	tween.tween_property($Sprite, "scale", Vector2(0,0), 1.2)
	tween.chain().tween_callback(self, "call_deferred", ["queue_free"])
