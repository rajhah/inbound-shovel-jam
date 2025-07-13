extends CharacterBody2D

var hp: int = 1
var speed: float = 90
var direction: Vector2

@export var player: CharacterBody2D

func _physics_process(delta: float) -> void:
	direction = (player.global_position - global_position).normalized()
	velocity = speed * direction
	move_and_slide()

func _hitByVaccuum():
	pass

func _die():
	pass


func setDefaults(pl: CharacterBody2D = null, sprite: Sprite2D = null, collider: CollisionShape2D = null, health: int = 1, speed: float = 100):
	player = pl
