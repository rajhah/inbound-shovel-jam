extends Area2D

var mainWeapon: CollisionPolygon2D
var spr: AnimatedSprite2D
var noSpr: Sprite2D
var fullXp := false
var suckTimer: Timer
var sfxPlayer: AudioStreamPlayer

func _ready() -> void:
	mainWeapon = $CollisionPolygon2D
	spr = $CollisionPolygon2D/AnimatedSprite2D
	suckTimer = $"../suck_timer"
	sfxPlayer = $"../VacuumSound"

	_on_suck_timer_timeout()

	noSpr = $Sprite2D
	noSpr.visible = false

	Global.xpBarFull.connect(_on_xp_bar_full)
	Global.trashCanDeleted.connect(_on_trash_can_deleted)
	Global.weaponScaleUpdated.connect(_weapon_scale_updated)


func _weapon_scale_updated():
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
		if !sfxPlayer.playing and Global.soundEnabled:
			sfxPlayer.volume_db = 0.0
			var rand = randf_range(0.9, 1.1)
			sfxPlayer.pitch_scale = rand
			sfxPlayer.play()
		var hitCount = 0
		var enemies = get_overlapping_bodies()
		for enemy in enemies:
			if hitCount < Global.mainWeaponHitMax:
				enemy.hit_by_vacuum(global_position)
				hitCount += 1

func _on_xp_bar_full():
	fullXp = true
	noSpr.visible = true
	suckTimer.stop()

func _on_trash_can_deleted():
	fullXp = false
	noSpr.visible = false
	_on_suck_timer_timeout()
	suckTimer.start()
