extends Enemy

@export var shootTime: float = 4.0
var bulletScene := preload("res://Scenes/Enemy/bullet.tscn")
@onready var shootTimer := $ShootTimer
var shooting := false
var target_angle: float
var bullet: Bullet
var piOverTwo := PI/2

func _internal_ready():
	var rand = randf_range(-0.2, 0.2)
	shootTimer.wait_time = shootTime + rand
	bullet = bulletScene.instantiate()
	bullet.visible = false
	get_parent().add_child(bullet)
	bullet.bulletDeath.connect(_bulletDie)

func _internal_process():
	if shooting:
		return
	if downTimer.is_stopped():
		rotation = target_angle
		target_angle = (player.global_position - global_position).angle() + piOverTwo
	if bullet and !bullet.visible:
		bullet.global_position = global_position

func _internal_get_collected():
	bullet.call_deferred("queue_free")

func _on_shoot_timer_timeout() -> void:
	if downTimer.is_stopped():
		shooting = true
		target_angle = (player.global_position - global_position).angle() + PI * 9/2
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation", target_angle, 0.2)
		tween.tween_callback(_shoot)

func _shoot():
	await get_tree().create_timer(0.4).timeout
	if bullet:
		bullet.initialize(global_position, target_angle - PI/2, 3.0, true)
		bullet.visible = true
		shootTimer.start()
		await get_tree().create_timer(0.4).timeout
		shooting = false

func _calculate_movement_direction() -> Vector2:
	var direction = Vector2.ZERO
	if shooting:
		return direction.normalized()

	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player > 570:
		Global.respawnEnemy.emit(self)
	if distance_to_player > follow_distance + follow_deadzone:
		direction += (player.global_position - global_position).normalized()
	return direction.normalized()

func _bulletDie(bul: Bullet):
	bul.visible = false
