# Dziq 2024 - 2028
# v0.-1





extends Node2D


export var small_screen  := false
export var game_duration := 60

var mob_timer_reduce_per_sec  = 2 / float(game_duration)





func _ready() -> void:
	randomize()
#	G.load_config()
	var LEVEL  = preload("res://Level.tscn").instance()
	add_child(LEVEL)
	window_prepare()
#	print(mob_timer_reduce_per_sec)






func window_prepare() -> void:
	var display_size = OS.get_screen_size()
	var window_size  = G.window

	if small_screen == true:
		window_size *= Vector2(.5, .5)
	else:
		window_size *= Vector2(4, 4)

	if display_size.y <= window_size.y:
		var scale_ratio = window_size.y / (display_size.y - 80)
		window_size.x /= scale_ratio ; window_size.y /= scale_ratio

	OS.window_size = window_size
	window_size.y += 64
	OS.window_position = display_size * .5 - window_size * .5
