extends CharacterBody2D
class_name Enemy

@export var enemy_type: Global.enemyType
@export var xpOnDeath: int = 5
@export var contactDamage: int = 3
@export var speed: float = 55.0
@export var follow_distance: float = 20.0
@export var follow_deadzone: float = 5.0
@export var health: float = 1.0
@export var downTime: int = 10
@export_range(0.0, 1.0, 0.05) var jitter_strength: float = 0.2
@export_range(0.1, 5.0, 0.1) var jitter_change_interval: float = 4.0

var player: Node2D
var jitter_direction
var jitter_time: float = 0.0

@onready var downTimer: Timer = $downTimer
var downState = false

@onready var col: CollisionShape2D = $CollisionShape2D

func _ready():
	downTimer.wait_time = downTime
	downTimer.stop()

	player = get_tree().get_first_node_in_group("player")
	add_to_group("enemies")

	_update_jitter_direction()
	jitter_time = randf() * jitter_change_interval
	_internal_ready()

func _internal_ready():
	pass

func _physics_process(delta: float) -> void:
	if not player or downState:
		return

	jitter_time -= delta
	if jitter_time <= 0:
		_update_jitter_direction()
		jitter_time = jitter_change_interval

	velocity = _calculate_movement_direction() * speed

	_internal_process()
	move_and_slide()
	_check_collisions()

func _internal_process():
	pass

func _update_jitter_direction():
	jitter_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()

func _check_collisions():
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		if collision.get_collider().name == "player":
			Global.loseHp.emit(contactDamage)

func _calculate_movement_direction() -> Vector2:
	var direction := Vector2.ZERO

	var distance_to_player := global_position.distance_to(player.global_position)
	if distance_to_player < follow_distance - follow_deadzone:
		direction += (global_position - player.global_position).normalized()
	elif distance_to_player > follow_distance + follow_deadzone:
		direction += (player.global_position - global_position).normalized()

	if distance_to_player > 570:
		Global.respawnEnemy.emit(self)

	direction += jitter_direction * jitter_strength

	return direction.normalized()

func hit_by_vacuum(vacPos: Vector2):
	health += -Global.mainWeaponDamage
	if health == 0:
		downTimer.start()
		downState = true
	elif health < 0:
		_get_collected(vacPos)

func _on_down_timer_timeout() -> void:
	downState = false

func _get_collected(vacPos: Vector2):
	_internal_get_collected()
	col.disabled = true
	player._gain_xp(xpOnDeath)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", vacPos, 0.25)
	tween.parallel().tween_property(self, "rotation", PI, 0.25)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.4)
	tween.tween_callback(_die)
	Global.trySpawnHealthPack(global_position)

func _internal_get_collected():
	pass

func _die():
	player.play_enemy_sfx(enemy_type)
	call_deferred("queue_free")
