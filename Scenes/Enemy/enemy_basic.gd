extends CharacterBody2D
class_name Enemy

@export var xpOnDeath: int = 100
@export var contactDamage: int = 10

@export var speed: float = 25.0
@export var acceleration: float = 500.0
@export var friction: float = 300.0

@export var separation_distance: float = 30.0
@export var separation_force: float = 150.0
@export var follow_distance: float = 20.0
@export var follow_deadzone: float = 5.0

@export var health: float = 0.0

@export var downTime: int = 10

var player: Node2D
var nearby_enemies: Array[Node2D] = []
@onready var downTimer: Timer = $downTimer
var downState = false

@onready var col: CollisionShape2D = $CollisionShape2D

signal dead

func _ready():
	downTimer.wait_time = downTime
	downTimer.stop()

	player = get_tree().get_first_node_in_group("player")
	if not player:
		print("Warning: No player found in 'player' group")
	add_to_group("enemies")

func _physics_process(delta):
	if not player:
		return

	if downState:
		return

	update_nearby_enemies()

	var target_velocity = calculate_movement_direction() * speed

	# Smooth velocity changes
	if target_velocity.length() > 0:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

	check_collisions()

func check_collisions():
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		if collision.get_collider().name == "player":
			player._lose_hp(contactDamage)

func update_nearby_enemies():
	nearby_enemies.clear()
	var enemies = get_tree().get_nodes_in_group("enemies")

	for enemy in enemies:
		if enemy != self and is_instance_valid(enemy):
			var distance = global_position.distance_to(enemy.global_position)
			if distance <= separation_distance * 2:
				nearby_enemies.append(enemy)

func calculate_movement_direction() -> Vector2:
	var direction = Vector2.ZERO

	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player < follow_distance - follow_deadzone:
		direction += (global_position - player.global_position).normalized()
	elif distance_to_player > follow_distance + follow_deadzone:
		direction += (player.global_position - global_position).normalized()

	direction += calculate_separation_direction()

	return direction.normalized()

func calculate_separation_direction() -> Vector2:
	if nearby_enemies.is_empty():
		return Vector2.ZERO

	var separation_vec = Vector2.ZERO

	for enemy in nearby_enemies:
		if not is_instance_valid(enemy):
			continue

		var distance = global_position.distance_to(enemy.global_position)
		if distance < separation_distance and distance > 0:
			var direction_away = (global_position - enemy.global_position).normalized()
			var force_magnitude = (separation_distance - distance) / separation_distance
			separation_vec += direction_away * force_magnitude

	return separation_vec.normalized() * (separation_force / 100.0)

func hit_by_vacuum(vacPos: Vector2):
	health += -Global.mainWeaponDamage
	if health == 0:
		downTimer.start()
		downState = true
	elif health < 0:
		get_collected(vacPos)

func _on_down_timer_timeout() -> void:
	downState = false

func get_collected(vacPos: Vector2):
	player._gain_xp(xpOnDeath)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", vacPos, 0.25)
	tween.parallel().tween_property(self, "rotation", PI, 0.25)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.4)
	tween.tween_callback(die)

func die():
	dead.emit(self)
	queue_free()
