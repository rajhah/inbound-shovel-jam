extends CharacterBody2D

var rightHold: bool
var leftHold: bool
var upHold: bool
var downHold: bool

var maxSpeed = 175
var playerSpeedMultiplier := 1.0
var vulnerable := true

var paperSound = preload("res://Assets/Sound/paper.mp3")
var bottleSound = preload("res://Assets/Sound/bottle.mp3")
var clothesSound = preload("res://Assets/Sound/clothes.mp3")
var levelUpSound = preload("res://Assets/Sound/levelup.mp3")
var hurtSound = preload("res://Assets/Sound/weird-grunt-85631.mp3")
var healSound = preload("res://Assets/Sound/heal.mp3")

var direction: Vector2:
	get:
		return direction.normalized()

var experience: int:
	get:
		if ui:
			return ui.xp
		else:
			return 0


var mousePosition
@export var ui: CanvasLayer

@onready var col := $CollisionShape2D
@onready var sfxPlayer := $Sfx

var maxLevel := false
var camera: Camera2D

func _ready() -> void:
	camera = $Camera2D
	add_to_group("player")
	Global.trashCanCreated.connect(_play_levelup_sfx)
	Global.trashCanDeleted.connect(_reset_xp)
	Global.maxLevelReached.connect(_max_level_reached)
	Global.loseHp.connect(_lose_hp)
	Global.healthPackDeleted.connect(_lose_hp)

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())

func _physics_process(_delta: float) -> void:
	rightHold = Input.is_action_pressed("right")
	leftHold = Input.is_action_pressed("left")
	upHold = Input.is_action_pressed("up")
	downHold = Input.is_action_pressed("down")

	#Debug commands
	if Input.is_action_pressed("LevelUp"):
		Global.trashCanDeleted.emit()
		Global.update_xp_scale_factor()
	if Input.is_action_pressed("Sudoku"):
		_lose_hp(100)

	if rightHold:
		direction.x = 1
	elif leftHold:
		direction.x = -1
	else:
		direction.x = 0

	if upHold:
		direction.y = -1
	elif downHold:
		direction.y = 1
	else:
		direction.y = 0

	velocity = maxSpeed * Global.playerSpeedMultiplier * direction.normalized()

	move_and_slide()

func _gain_xp(xp: int):
	if ui.xp < 100:
		ui.xp += xp * Global.playerXpScaleFactor
		if ui.xp >= 100 and !maxLevel:
			Global.xpBarFull.emit()
			Global.update_xp_scale_factor()

func play_enemy_sfx(enemy_type: Global.enemyType):
	if !sfxPlayer.playing and Global.soundEnabled:
		var rand = randf_range(0.9, 1.1)
		match enemy_type:
			Global.enemyType.PAPER:
				sfxPlayer.stream = paperSound
				sfxPlayer.pitch_scale = rand
				sfxPlayer.play()
			Global.enemyType.BOTTLE:
				sfxPlayer.stream = bottleSound
				sfxPlayer.pitch_scale = rand
				sfxPlayer.play()
			Global.enemyType.CLOTHES:
				sfxPlayer.stream = clothesSound
				sfxPlayer.pitch_scale = rand
				sfxPlayer.play()

func _play_levelup_sfx(_trashCanInstance):
	if Global.soundEnabled:
		sfxPlayer.stop()
		sfxPlayer.stream = levelUpSound
		sfxPlayer.play()

func _play_hurt_sfx():
	if Global.soundEnabled:
		sfxPlayer.stop()
		var rand = randf_range(0.8, 1.2)
		sfxPlayer.stream = hurtSound
		sfxPlayer.pitch_scale = rand
		sfxPlayer.play()

func _play_heal_sfx():
		if Global.soundEnabled:
			sfxPlayer.stop()
			var rand = randf_range(0.9, 1.1)
			sfxPlayer.stream = healSound
			sfxPlayer.pitch_scale = rand
			sfxPlayer.play()

func _max_level_reached():
	maxLevel = true

func _reset_xp():
	ui.xp = 0

func _lose_hp(hp: int):
	if hp < 0:
		var heal = -hp
		ui.hp = min(100, ui.hp + heal)
		_play_heal_sfx()
	elif vulnerable:
		ui.hp += -hp
		_play_hurt_sfx()
		if ui.hp > 0:
			vulnerable = false
			col.set_deferred("disabled", true)
			camera.shake()
			await get_tree().create_timer(Global.playerInvulnTime).timeout
			vulnerable = true
			col.disabled = false
		else:
			die()

func die():
	Global.playerDied.emit()
	await get_tree().process_frame
	for bullet in get_tree().get_nodes_in_group("bullets"):
		bullet.call_deferred("queue_free")
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.call_deferred("queue_free")
	for trashcan in get_tree().get_nodes_in_group("trashCan"):
		trashcan.call_deferred("queue_free")
	call_deferred("queue_free")
