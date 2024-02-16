extends Area2D


onready var node  = $"../Sounds/Collect"


var value : int






func _ready() -> void:
	animate()






func animate() -> void:
	var tween  = self.create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($sprite, "rotation_degrees", randi()%360, 1)
	tween.tween_callback(self, "animate")






func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.experience += value
		body.exp_print()

		node.stream  = load("res://data/sounds/gem_collect.wav")
		node.pitch_scale  = 1 + rand_range(-.1, .1)
		node.play()
		queue_free()
