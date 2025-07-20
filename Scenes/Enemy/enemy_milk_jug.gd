extends Enemy

class_name MilkJug

@export var numBullets: int = 16
@onready var shootTimer := $shootTimer
@onready var spr := $Sprite2D
var shooting := false
var target_angle: float
var bulletScene = preload("res://Scenes/Enemy/bullet.tscn")

var bulletArray: Array[Bullet] = []

func _internal_ready():
	var rand = randf_range(-0.4, 0.4)
	shootTimer.wait_time += rand
	for i in range(16):
		bulletArray.append(bulletScene.instantiate())
		add_child(bulletArray[i])
		bulletArray[i].velocity = 0
		bulletArray[i].visible = false
		bulletArray[i].bulletDeath.connect(_resetBullet)

func _internal_process():
	if shooting:
		velocity = Vector2.ZERO

func _internal_get_collected():
	for bullet in bulletArray:
		bullet.call_deferred("queue_free")
	bulletArray.clear()

func _on_shoot_timer_timeout() -> void:
	if downTimer.is_stopped():
		shooting = true
		_shrink()

func _shrink():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(spr, "scale", Vector2(0.7, 0.7), 0.5)
	tween.tween_callback(_expand)

func _expand():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(spr, "scale", Vector2(1, 1), 3.0)
	_shoot()

func _shoot():
	var i = 0
	var piOverBullets = PI/(numBullets/2)
	for bullet in bulletArray:
		var angle = i * piOverBullets
		bullet.velocity = 2
		bullet.visible = true
		bullet.initialize(global_position, angle, 5.0, true)
		i += 1

	shootTimer.start()
	await get_tree().create_timer(0.4).timeout
	shooting = false

func _resetBullet(bul: Bullet):
	bul.visible = false
	bul.initialize(global_position, 0.0, 5.0, false)
