extends Area2D


export var SPEED  := 400.0
export var RANGE  := 2400
export var DAMAGE := 8


var traveled_distance := 0.0






func _ready() -> void:
	var node       = $"/root/SYST/Level/Sounds/Shoot"
	node.stream    = load("res://data/sounds/pistol"+str(randi()%3+1)+".ogg")
	node.play()






func _physics_process(delta: float) -> void:
	var direction  = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta

	traveled_distance += SPEED * delta
	if traveled_distance > RANGE:
		queue_free()






func _on_body_entered(body: Node) -> void:
	queue_free()

	if body.has_node("damage"):
		body.get_node("damage").take_damage(DAMAGE)
		body.pushback(false)
