extends Area2D


onready var node  = $"../../Sounds/Collect"


var value : int
# Declare member variables here. Examples:
# var a: int = 2wd
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
#func _physics_process(delta: float) -> void:
#	get_overlapping_bodies()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.experience += value
		body.exp_print()

		var path     = "res://data/sounds/gem_collect.wav"
		node.stream  = load(path)
		node.pitch_scale  = 1 + rand_range(-.1, .1)
		node.play()
		queue_free()
