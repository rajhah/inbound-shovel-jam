extends Area2D

class_name Bullet

@export var velocity := 5
@export var contactDamage := 3
@export var bulletDeathTime := 3.0
@onready var polygon := $Polygon2D
var hue := 0.0
var target: Vector2
var direction: Vector2
@onready var ttl_timer := $TTLTimer
signal bulletDeath

func initialize(pos: Vector2, rot: float, time_to_live: float = 3.0, timer_autostart: bool = true):
	global_position = pos
	direction = Vector2.from_angle(rot).normalized()
	ttl_timer.wait_time = time_to_live
	if timer_autostart:
		ttl_timer.start()
	rotation = rot + PI/2

func _ready() -> void:
	add_to_group("bullets")

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
	bulletDeath.emit(self)
