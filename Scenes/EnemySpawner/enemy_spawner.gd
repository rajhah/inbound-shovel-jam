extends Node2D

@export var levels: Array[LevelResource]

var trashCan = preload("res://Scenes/Trashcan/trash_can.tscn")

var player: CharacterBody2D
var currentLevel: int = 0
var currentWave: int = 0
var waveTimer: Timer

var currentLevelEnemies: Array = []

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not player:
		print("Warning: No player found in 'player' group")

	Global.xpBarFull.connect(_spawn_trash_can)

	waveTimer = Timer.new()
	waveTimer.one_shot = true
	waveTimer.timeout.connect(_on_wave_timer_timeout)
	add_child(waveTimer)
	if levels.size() > 0:
		_start_wave()

func _start_wave():
	var currentLevelResource = levels[currentLevel]

	if currentLevel >= levels.size():
		print_debug("all levels complete")
		return

	var currentWaveResource = currentLevelResource.waves[currentWave]

	waveTimer.wait_time = currentWaveResource.delay
	waveTimer.start()

func _on_wave_timer_timeout():
	var currentWaveResource = levels[currentLevel].waves[currentWave]

	_spawn_enemies(currentWaveResource.enemies, currentWaveResource.spawn_type)
	if currentWave + 1 < levels[currentLevel].waves.size():
		currentWave += 1
		_start_wave()

func _spawn_enemies(enemyDict: Dictionary, spawnType: String):
	for enemyScene in enemyDict:
		var count = enemyDict[enemyScene]
		if enemyScene != null:
			for i in range(count):
				var enemy = enemyScene.instantiate()
				enemy.position = _calculateSpawnPosition(spawnType)
				add_child(enemy)
				currentLevelEnemies.append(enemy)
				enemy.connect("dead", _on_enemy_died)

func _spawn_trash_can():
	if get_tree().get_nodes_in_group("trashCan").is_empty():
		var can = trashCan.instantiate()
		can.position = _calculateSpawnPosition("circle")
		add_child(can)
		can.add_to_group("trashCan")
		Global.trashCanCreated.emit(can)

func _on_enemy_died(enemy):
	currentLevelEnemies.erase(enemy)
	if currentLevelEnemies.is_empty() and currentWave + 1 == levels[currentLevel].waves.size():
		_on_level_complete()

func _on_level_complete():
	await get_tree().create_timer(levels[currentLevel].timeBeforeStartingNextLevel).timeout
	if currentLevel + 1 < levels.size():
		currentLevel += 1
		currentWave = 0
		_start_wave()

func _calculateSpawnPosition(spawnType: String) -> Vector2:
	var ppos = player.global_position
	var pdir = player.direction
	if pdir != Vector2.ZERO and spawnType == "normal":
			var perpendicular = Vector2(-pdir.y, pdir.x)
			var forwardOffset = pdir * 400
			var sideOffset = perpendicular * randf_range(-100, 100)
			return ppos + forwardOffset + sideOffset
	else:
		var random_angle = randf() * 2 * PI
		return ppos + Vector2(cos(random_angle), sin(random_angle)) * 400
