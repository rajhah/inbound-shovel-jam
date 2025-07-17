extends Area2D

var mainWeapon: CollisionPolygon2D
var spr: AnimatedSprite2D
var noSpr: Sprite2D
var fullXp := false

func _ready() -> void:
	mainWeapon = $CollisionPolygon2D
	spr = $CollisionPolygon2D/AnimatedSprite2D
	_on_suck_timer_timeout()

	noSpr = $Sprite2D
	noSpr.visible = false

	Global.xpBarFull.connect(_on_xp_bar_full)
	Global.trashCanDeleted.connect(_on_trash_can_deleted)
	Global.attributeUpdated.connect(_check_attributes)

func _check_attributes():
	if mainWeapon.scale.x != Global.mainWeaponSize:
		mainWeapon.scale = Vector2(Global.mainWeaponSize, Global.mainWeaponSize)

func _on_suck_timer_timeout() -> void:
	if !fullXp:
		spr.visible = true
		var target_fps = 5.0 / Global.mainWeaponCooldown
		spr.speed_scale = target_fps / 5.0
		spr.play("default")

func _on_animated_sprite_2d_animation_finished() -> void:
	spr.visible = false
	if !fullXp:
		var hitCount = 0
		var enemies = get_overlapping_bodies()
		for enemy in enemies:
			if hitCount < Global.mainWeaponHitMax:
				enemy.hit_by_vacuum(global_position)
				hitCount += 1

func _on_xp_bar_full():
	fullXp = true
	noSpr.visible = true

func _on_trash_can_deleted():
	fullXp = false
	noSpr.visible = false
	var target_fps = 5.0 / Global.mainWeaponCooldown
	spr.speed_scale = target_fps / 5.0
	spr.play("default")
