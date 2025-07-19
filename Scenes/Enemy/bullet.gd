extends Area2D

@export var velocity := 5
@export var contactDamage := 3
@onready var polygon := $Polygon2D
var hue := 0.0
var target: Vector2
var player: Node2D
var direction: Vector2


func initialize(pos: Vector2, targ: Vector2):
	global_position = pos
	target = targ
	direction = (target - global_position).normalized()
	rotation = get_angle_to(targ) + PI/2

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
		hue += 1.2 * delta
		if hue > 1.0:
			hue = 0.0
		polygon.modulate = Color.from_hsv(hue, 1.0, 1.0)

func _physics_process(_delta: float) -> void:
	global_position += velocity * direction

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Global.loseHp.emit(contactDamage)
		call_deferred("die")

func _on_ttl_timer_timeout() -> void:
	call_deferred("die")

func die():
	queue_free()
