extends Node

var healthPackScene = preload("res://Scenes/Trashcan/health_pack.tscn")

var mainWeaponCooldownLevels = [2.0, 1.6, 1.2, 1.0, 0.9]
var mainWeaponCooldownIndex = 0
var mainWeaponCooldown: float = 2.0

var mainWeaponDamageLevels = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
var mainWeaponDamageIndex = 0
var mainWeaponDamage: float = 1.0

var playerSpeedMultiplierLevels = [1.0, 1.4, 1.6, 1.8, 2.0]
var playerSpeedMultiplierIndex = 0
var playerSpeedMultiplier: float = 1.0
#These are used directly and only need to be updated here

var playerInvulnTimeLevels = [1.0, 2.0, 3.0, 4.0, 5.0]
var playerInvulnTimeIndex = 0
var playerInvulnTime: float = 1.0

#This one needs to be updated
var mainWeaponSizeLevels = [2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]
var mainWeaponSizeIndex = 0
var mainWeaponSize: float = 2.0

var playerLevel: int = 0
var playerXpScaleFactor: float = 1.0

var mainWeaponHitMax: int = 5
var mainWeaponHitMaxIncrease: int = 2

signal currentWave
signal xpBarFull
signal maxLevelReached
signal trashCanCreated
signal trashCanDeleted
signal healthPackDeleted

signal attributeUpdated
signal weaponScaleUpdated
signal disableButton

signal playerDied

signal musicOn
signal musicOff

signal closeDebugMenu
signal setCurrentLevel
signal loseHp

signal respawnEnemy

enum ButtonType {
	PLAYERINVULNTIME,
	PLAYERSPEED,
	WEAPONCOOLDOWN,
	WEAPONDAMAGE,
	WEAPONSCALE
}

enum enemyType {
	PAPER,
	BOTTLE,
	CLOTHES
}

var soundEnabled := true
var musicEnabled := true

func _ready() -> void:
	mainWeaponCooldown = mainWeaponCooldownLevels[mainWeaponCooldownIndex]
	mainWeaponDamage = mainWeaponDamageLevels[mainWeaponDamageIndex]
	playerSpeedMultiplier = playerSpeedMultiplierLevels[playerSpeedMultiplierIndex]
	playerInvulnTime = playerInvulnTimeLevels[playerInvulnTimeIndex]
	mainWeaponSize = mainWeaponSizeLevels[mainWeaponSizeIndex]

	attributeUpdated.connect(_attribute_updated)

func update_xp_scale_factor():
	playerXpScaleFactor = max(0.1, pow(0.90, playerLevel - 1))

func resetAttributes():
	mainWeaponHitMax = 5
	mainWeaponCooldownIndex = 0
	mainWeaponDamageIndex = 0
	playerSpeedMultiplierIndex = 0
	playerInvulnTimeIndex = 0
	mainWeaponSizeIndex = 0
	playerLevel = 0
	playerXpScaleFactor = 1.0
	_attribute_updated()

func _attribute_updated():
	playerLevel += 1
	mainWeaponHitMax += mainWeaponHitMaxIncrease

	if mainWeaponCooldown != mainWeaponCooldownLevels[mainWeaponCooldownIndex]:
		mainWeaponCooldown = mainWeaponCooldownLevels[mainWeaponCooldownIndex]

	if mainWeaponDamage != mainWeaponDamageLevels[mainWeaponDamageIndex]:
		mainWeaponDamage = mainWeaponDamageLevels[mainWeaponDamageIndex]

	if playerSpeedMultiplier != playerSpeedMultiplierLevels[playerSpeedMultiplierIndex]:
		playerSpeedMultiplier = playerSpeedMultiplierLevels[playerSpeedMultiplierIndex]

	if playerInvulnTime != playerInvulnTimeLevels[playerInvulnTimeIndex]:
		playerInvulnTime = playerInvulnTimeLevels[playerInvulnTimeIndex]

	if mainWeaponSize != mainWeaponSizeLevels[mainWeaponSizeIndex]:
		mainWeaponSize = mainWeaponSizeLevels[mainWeaponSizeIndex]
		weaponScaleUpdated.emit()

func toggle_sound():
	soundEnabled = !soundEnabled

func toggle_music():
	musicEnabled = !musicEnabled
	if musicEnabled:
		musicOn.emit()
	else:
		musicOff.emit()

func trySpawnHealthPack(pos: Vector2):
	if randi_range(0, 39) == 17:
		var healthPack = healthPackScene.instantiate()
		healthPack.global_position = pos
		get_tree().current_scene.add_child(healthPack)
