extends Camera2D


export var zoom_step  := 0.12
export var max_zoom   := 1.64
export var min_zoom   := .4


var target_zoom          := Vector2.ZERO






func _process(delta: float) -> void:
	if zoom != target_zoom:
		var i        = clamp(target_zoom.x, min_zoom, max_zoom)
		target_zoom  = Vector2(i,i)
		zoom         = lerp(zoom, target_zoom, zoom_step * 20 * delta)






func _input(event: InputEvent) -> void:
	#cam zooming:
	if event.is_pressed():
		if event.is_action_pressed("zoom+"):
			target_zoom -= Vector2(zoom_step, zoom_step)
		elif event.is_action_pressed("zoom-"):
			target_zoom += Vector2(zoom_step, zoom_step)
