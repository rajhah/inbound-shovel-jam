extends CharacterBody2D

var rightHold: bool
var leftHold: bool
var upHold: bool
var downHold: bool

var maxSpeed = 175
var playerSpeedMultiplier := 1.0

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
@export var overlay: TextureRect

@onready var col := $CollisionShape2D

func _ready() -> void:
	add_to_group("player")
	Global.trashCanDeleted.connect(_reset_xp)

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())

func _physics_process(_delta: float) -> void:
	rightHold = Input.is_action_pressed("right")
	leftHold = Input.is_action_pressed("left")
	upHold = Input.is_action_pressed("up")
	downHold = Input.is_action_pressed("down")

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
		if ui.xp >= 100:
			Global.xpBarFull.emit()
			if Global.playerXpScaleFactor > Global.playerXpScaleFactorMin:
				Global.playerXpScaleFactor += Global.playerXpScaleFactorIncrease

func _reset_xp():
	ui.xp = 0

func _lose_hp(hp: int):
	ui.hp += -hp
	if ui.hp > 0:
		col.disabled = true
		await get_tree().create_timer(Global.playerInvulnTime).timeout
		col.disabled = false
	else:
		die()

func die():
	Global.playerDied.emit()
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	queue_free()
