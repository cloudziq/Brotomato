extends KinematicBody2D



export var ATT_SPEED := 86.0
export var MELEE     := 6.0



onready var player       = get_node("../Player")
onready var level        = get_node("../../../Level")






func _ready() -> void:
	scale  *= rand_range(.94, 1.06)
	$Sprite.self_modulate.r *= rand_range(.92, 1)
	$Sprite.self_modulate.g *= rand_range(.80, 1)
	$AnimPlayer.play("move")






func pushback(stun:=false, melee:=0.0) -> void:
	var strength  = 1 if has_node("damage") and $damage.HEALTH > 0 else 4
	strength += melee * 1.4
#	strength = max(22, strength + melee * .8)
	var tween    := get_tree().create_tween().set_trans(8).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position",
		global_position + -$move.direction * strength, 1.125)

	if stun:
		$move.set_physics_process(false)
		$AnimPlayer.play("stun_in")
	var t  = self.create_tween()
	t.tween_callback(self, "pushback_end").set_delay(player.MELEE - ($damage.STAMINA * .04))






func pushback_end() -> void:
	if has_node("damage") and $damage.HEALTH > 0:
		$move.set_physics_process(true)
		$AnimPlayer.play("stun_out")
		$AnimPlayer.queue("move")






func remove() -> void:
	var tween  = get_tree().create_tween().set_parallel()
	tween.tween_property($Sprite, "modulate", Color(1,1,1,0), 1)
	tween.tween_property($Sprite, "scale", Vector2(0,0), 1.2)
	tween.chain().tween_callback(self, "queue_free")
