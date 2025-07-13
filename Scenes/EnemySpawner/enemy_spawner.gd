extends Node2D

@export var enemyNumber: int
@export var player: CharacterBody2D

var enemyScene = preload("res://Scenes/Enemy/enemy.tscn")

var enemy_dict: Dictionary

func _ready() -> void:
	enemy_dict[enemyScene] = enemyNumber
	await get_tree().create_timer(1).timeout
	_spawn_enemies()

func _spawn_enemies():
	for enemy_scene in enemy_dict:
		var count = enemy_dict[enemy_scene]
		for i in range(count):
			var enemy_instance = enemy_scene.instantiate()
			enemy_instance.position = _calculateSpawnPosition()
#			enemy_instance.setDefaults(player)
			add_child(enemy_instance)


func _calculateSpawnPosition() -> Vector2:
	var ppos = player.global_position
	var pdir = player.direction
	if pdir != Vector2.ZERO:
		return ppos + Vector2(pdir.x + randf() * (.3 * pdir.y), pdir.y + randf() * (.3 * pdir.x)) * 400
	else:
		var random_angle = randf() * 2 * PI
		return ppos + Vector2(cos(random_angle), sin(random_angle)) * 400
