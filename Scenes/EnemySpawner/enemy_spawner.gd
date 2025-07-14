extends Node2D

@export var levels: Array[LevelResource]

var player: CharacterBody2D
var currentLevel: int = 0
var currentWave: int = 0
var waveTimer: Timer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not player:
		print("Warning: No player found in 'player' group")

	Global.BossDefeated.connect(_on_boss_defeated)

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

	if currentWave >= currentLevelResource.waves.size():
		currentWave = 0

	var currentWaveResource = currentLevelResource.waves[currentWave]

	waveTimer.wait_time = currentWaveResource.delay
	waveTimer.start()





func _on_wave_timer_timeout():
	var currentWaveResource = levels[currentLevel].waves[currentWave]
	var trigger = currentWaveResource.endWaveTrigger

	if trigger == "defeat":
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.queue_free()

	_spawn_enemies(currentWaveResource.enemies, currentWaveResource.spawn_type)

	if trigger == "timer":
		currentWave += 1
		_start_wave()


func _on_boss_defeated():
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
