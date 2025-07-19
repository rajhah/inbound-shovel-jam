extends Node

var mainWeaponCooldownLevels = [2.0, 1.6, 1.2, 0.8, 0.4]
var mainWeaponCooldownIndex = 0
var mainWeaponCooldown: float = 2.0

var mainWeaponTargetsLevels = [5, 7, 9, 10, 11]
var mainWeaponTargetsIndex = 0
var mainWeaponHitMax: int = 5

var mainWeaponDamageLevels = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
var mainWeaponDamageIndex = 0
var mainWeaponDamage: float = 1.0

var playerSpeedMultiplierLevels = [1.0, 1.2, 1.4, 1.6, 1.8, 2.0]
var playerSpeedMultiplierIndex = 0
var playerSpeedMultiplier: float = 1.0
#These are used directly and only need to be updated here

var playerInvulnTimeLevels = [1.0, 1.5, 2.0, 2.2, 2.4, 2.6, 2.8, 3.0]
var playerInvulnTimeIndex = 0
var playerInvulnTime: float = 1.0

#This one needs to be updated
var mainWeaponSizeLevels = [2.0, 2.6, 3.2, 3.8, 4.4, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0]
var mainWeaponSizeIndex = 0
var mainWeaponSize: float = 2.0

var playerXpScaleFactor: float = 1.0
var playerXpScaleFactorIncrease: float = -0.1
var playerXpScaleFactorMin: float = 0.1

signal xpBarFull
signal maxLevelReached
signal trashCanCreated
signal trashCanDeleted

signal attributeUpdated
signal weaponScaleUpdated
signal disableButton

signal playerDied

signal musicOn
signal musicOff

signal closeDebugMenu
signal setCurrentLevel

enum ButtonType {
	PLAYERINVULNTIME,
	PLAYERSPEED,
	WEAPONCOOLDOWN,
	WEAPONDAMAGE,
	WEAPONHITMAX,
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
	mainWeaponHitMax = mainWeaponTargetsLevels[mainWeaponTargetsIndex]
	mainWeaponDamage = mainWeaponDamageLevels[mainWeaponDamageIndex]
	playerSpeedMultiplier = playerSpeedMultiplierLevels[playerSpeedMultiplierIndex]
	playerInvulnTime = playerInvulnTimeLevels[playerInvulnTimeIndex]
	mainWeaponSize = mainWeaponSizeLevels[mainWeaponSizeIndex]

	attributeUpdated.connect(_attribute_updated)


func _attribute_updated():
	if mainWeaponCooldown != mainWeaponCooldownLevels[mainWeaponCooldownIndex]:
		mainWeaponCooldown = mainWeaponCooldownLevels[mainWeaponCooldownIndex]

	if mainWeaponHitMax != mainWeaponTargetsLevels[mainWeaponTargetsIndex]:
		mainWeaponHitMax = mainWeaponTargetsLevels[mainWeaponTargetsIndex]

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
