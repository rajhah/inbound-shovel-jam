extends Area2D

var mainWeapon: CollisionPolygon2D

func _ready() -> void:
	mainWeapon = $CollisionPolygon2D

func _process(_delta: float) -> void:
	if mainWeapon.scale.x != Global.mainWeaponSize:
		mainWeapon.scale = Vector2(Global.mainWeaponSize, Global.mainWeaponSize)

func _on_suck_timer_timeout() -> void:
	var hitCount = 0
	var enemies = get_overlapping_bodies()
	for enemy in enemies:
		if hitCount < Global.mainWeaponHitMax:
			enemy.hit_by_vacuum()
			hitCount += 1
