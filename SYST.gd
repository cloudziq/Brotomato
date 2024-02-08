# Dziq 2023 - 2023
# v0.-1





extends Node2D


export var rec : bool





func _ready() -> void:
	randomize()
#	G.load_config()
	window_prepare()






func window_prepare() -> void:
	var display_size = OS.get_screen_size()
	var window_size  = G.window

	if rec == true:
		window_size *= Vector2(1.16, 1.16)
	else:
		window_size *= Vector2(4, 4)

	if display_size.y <= window_size.y:
		var scale_ratio = window_size.y / (display_size.y - 80)
		window_size.x /= scale_ratio ; window_size.y /= scale_ratio

	OS.window_size = window_size
	window_size.y += 64
	OS.window_position = display_size * .5 - window_size * .5
