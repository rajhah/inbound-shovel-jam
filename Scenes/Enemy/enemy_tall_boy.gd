extends Enemy

var bulletScene := preload("res://Scenes/Enemy/bullet.tscn")
@onready var shootTimer := $ShootTimer
var shooting := false
var target_angle: float

func _internal_ready():
	var rand = randf_range(-0.2, 0.2)
	shootTimer.wait_time += rand

func _internal_process():
	if downTimer.is_stopped():
		rotation = target_angle
		target_angle = (player.global_position - global_position).angle() + PI/2

func _on_shoot_timer_timeout() -> void:
	if downTimer.is_stopped():
		shooting = true
		target_angle = (player.global_position - global_position).angle() + PI * 6/2
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation", target_angle, 0.2)
		tween.tween_callback(_shoot)

func _shoot():
	await get_tree().create_timer(0.4).timeout
	var bullet = bulletScene.instantiate()
	bullet.initialize(global_position, player.global_position)
	get_parent().add_child(bullet)
	shootTimer.start()
	await get_tree().create_timer(0.4).timeout
	shooting = false

func _calculate_movement_direction() -> Vector2:
	var direction = Vector2.ZERO
	if shooting:
		return direction.normalized()

	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player > follow_distance + follow_deadzone:
		direction += (player.global_position - global_position).normalized()
	direction += _calculate_separation_direction()
	return direction.normalized()
