extends Node2D

@export var levels: Array[LevelResource]

var trashCan = preload("res://Scenes/Trashcan/trash_can.tscn")
var trashCanInstance

var player: CharacterBody2D
var currentLevel: int = 0
var currentWave: int = 0
var waveTimer: Timer

var validVectors = [
	Vector2(1.0, -1.0),
	Vector2(1.0, 0.0),
	Vector2(1.0, 1.0),
	Vector2(-1.0, -1.0),
	Vector2(-1.0, 0.0),
	Vector2(-1.0, 1.0),
	Vector2(0.0, 1.0),
	Vector2(0.0, -1.0),
]

var thisRandomVector: Vector2

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not player:
		print("Warning: No player found in 'player' group")

	Global.xpBarFull.connect(_spawn_trash_can)
	Global.setCurrentLevel.connect(_set_current_level)
	Global.respawnEnemy.connect(_respawn_enemy)

	waveTimer = Timer.new()
	waveTimer.one_shot = true
	waveTimer.timeout.connect(_on_wave_timer_timeout)
	add_child(waveTimer)
	if levels.size() > 0:
		call_deferred("_start_wave")

func _process(_delta: float) -> void:
	if player and trashCanInstance:
		if trashCanInstance.global_position.distance_to(player.global_position) > 1800:
			trashCanInstance.global_position = _calculateSpawnPosition("normal")
			Global.trashCanCreated.emit(trashCanInstance)

func _respawn_enemy(e: Enemy):
	e.global_position = _calculateSpawnPosition("normal")

func _set_current_level(level: int):
	_clear_all_enemies()
	currentLevel = level
	currentWave = 0
	_on_wave_timer_timeout()

func _clear_all_enemies():
	for i in get_tree().get_nodes_in_group("enemies"):
		i.call_deferred("queue_free")
	for bullet in get_tree().get_nodes_in_group("bullets"):
		bullet.call_deferred("queue_free")

func _start_wave():
	#if get_tree().get_nodes_in_group("enemies").size() > 99:
		#await get_tree().create_timer(10).timeout
		#_start_wave()

	var currentLevelResource = levels[currentLevel]

	if currentLevel >= levels.size():
		currentLevel -= 1
		currentWave = 0
		_on_wave_timer_timeout()
		return

	Global.currentWave.emit(currentLevel + 1, levels.size(), currentWave + 1, currentLevelResource.waves.size())

	var currentWaveResource = currentLevelResource.waves[currentWave]

	if currentLevel == 0 and currentWave == 0:
		_on_wave_timer_timeout()
	else:
		waveTimer.wait_time = currentWaveResource.delay
		waveTimer.start()

func _on_wave_timer_timeout():
	var currentWaveResource = levels[currentLevel].waves[currentWave]

	_spawn_enemies(currentWaveResource.enemies, currentWaveResource.spawn_type)
	if currentWave + 1 < levels[currentLevel].waves.size():
		currentWave += 1
		_start_wave()
	else:
		_on_level_complete()

func _spawn_enemies(enemyDict: Dictionary, spawnType: String):
	for enemyScene in enemyDict:
		var count = enemyDict[enemyScene]
		if enemyScene != null:
			thisRandomVector = _get_random_vector()
			for i in range(count):
				var enemy = enemyScene.instantiate()
				enemy.position = _calculateSpawnPosition(spawnType)
				add_child(enemy)

func _spawn_trash_can():
	if get_tree().get_nodes_in_group("trashCan").is_empty():
		trashCanInstance = trashCan.instantiate()
		trashCanInstance.position = _calculateSpawnPosition("trashCan")
		add_child(trashCanInstance)
		trashCanInstance.add_to_group("trashCan")
		Global.trashCanCreated.emit(trashCanInstance)

func _on_level_complete():
	await get_tree().create_timer(levels[currentLevel].timeBeforeStartingNextLevel).timeout
	if currentLevel + 1 < levels.size():
		currentLevel += 1
		currentWave = 0
		_start_wave()

func _calculateSpawnPosition(spawnType: String) -> Vector2:
	if not player:
		return Vector2.ZERO

	var distance = 500
	if spawnType == "trashCan":
		distance = 900
	var ppos = player.global_position
	if spawnType == "normal":
			var pdir = player.direction
			var perpendicular: Vector2
			if pdir == Vector2.ZERO:
				pdir = thisRandomVector
			perpendicular = Vector2(-pdir.y, pdir.x)
			var forwardOffset = pdir * distance
			var sideOffset = perpendicular * randf_range(-300, 300)
			return ppos + forwardOffset + sideOffset
	else:
		var random_angle = randf() * 2 * PI
		return ppos + Vector2(cos(random_angle), sin(random_angle)) * distance

func _get_random_vector() -> Vector2:
	return validVectors[randi_range(0, validVectors.size() - 1)]
