extends Camera2D


export var zoom_step  := 0.12
export var max_zoom   := 1.64
export var min_zoom   := .2


var target_zoom          := Vector2(1,1)



func _ready() -> void:
	$"../EnemySpawn".scale  = Vector2(max_zoom, max_zoom)
	$"../MobVisArea".scale  = Vector2(max_zoom, max_zoom)




func _process(delta: float) -> void:
	if zoom != target_zoom:
		var i        = clamp(target_zoom.x, min_zoom, max_zoom)
		target_zoom  = Vector2(i,i)
		zoom         = lerp(zoom, target_zoom, zoom_step * 20 * delta)

#		var node  = $"../EnemySpawn"
#		if target_zoom < zoom:
#			node.scale  = lerp(node.scale, target_zoom, zoom_step * 20 * delta)
#		else:
#			node.scale  = target_zoom






func _input(event: InputEvent) -> void:
	#cam zooming:
	if event.is_pressed():
		if event.is_action_pressed("zoom+"):
			target_zoom -= Vector2(zoom_step, zoom_step)
		elif event.is_action_pressed("zoom-"):
			target_zoom += Vector2(zoom_step, zoom_step)
