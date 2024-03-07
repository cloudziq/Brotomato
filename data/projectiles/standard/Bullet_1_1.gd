extends Area2D


export var SPEED     := 400.0
export var RANGE     := 2600
export var DAMAGE    := 6
export var PENETRATE := 1


var traveled_distance := 0.0
var player_target     :  int





func _ready() -> void:
	var sound    := $"/root/SYST/Level/Sounds/Shoot"
	sound.stream  = load("res://data/sounds/pistol"+str(randi()%3+1)+".ogg")
	sound.play()






func _physics_process(delta: float) -> void:
	var direction  = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta

	traveled_distance += SPEED * delta
	if traveled_distance > RANGE:
		queue_free()






func _on_body_entered(body: Node) -> void:
	if body.has_node("health"):
		body.get_node("health").take_damage(DAMAGE)
	body.pushback()
	queue_free()
