extends Area2D


export var SPEED  := 400.0
export var RANGE  := 2200
export var DAMAGE := 6.0


var traveled_distance := 0.0



func _ready() -> void:
	var node       = $"/root/SYST/Level/Sounds/Shoot"
	var path       = "res://data/sounds/pistol"+str(randi()%3+1)+".ogg"
	node.stream    = load(path)
	node.play()




func _physics_process(delta: float) -> void:
	var direction  = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta

	traveled_distance += SPEED * delta
	if traveled_distance > RANGE:
		queue_free()






func _on_body_entered(body: Node) -> void:
	queue_free()

	if body.has_method("take_damage"):
		body.take_damage(DAMAGE)
		body.pushback(false)
