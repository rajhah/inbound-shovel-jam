extends Area2D

var mainWeapon: CollisionPolygon2D
var spr: AnimatedSprite2D

func _ready() -> void:
	mainWeapon = $CollisionPolygon2D
	spr = $"../AnimatedSprite2D"
	spr.visible = false

func _process(_delta: float) -> void:
	if mainWeapon.scale.x != Global.mainWeaponSize:
		mainWeapon.scale = Vector2(Global.mainWeaponSize, Global.mainWeaponSize)

func _on_suck_timer_timeout() -> void:
	spr.visible = true
	spr.play("default")

func _on_animated_sprite_2d_animation_finished() -> void:
	spr.visible = false
	var hitCount = 0
	var enemies = get_overlapping_bodies()
	for enemy in enemies:
		if hitCount < Global.mainWeaponHitMax:
			enemy.hit_by_vacuum(global_position)
			hitCount += 1
