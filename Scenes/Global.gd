extends Node

#These are used directly and only need to be updated here
var mainWeaponCooldown: float = 2.0
var mainWeaponHitMax: int = 5
var mainWeaponDamage: float = 1.0
var playerSpeedMultiplier: float = 1.0
var playerInvulnTime: float = 2.0

#This one needs to be updated
var mainWeaponSize: float = 2.0


var mainWeaponCooldownMax: float = 0.4
var mainWeaponHitMaxTargets: float = 50
var mainWeaponDamageMax: float = 5
var mainWeaponSizeMax: float = 8.0
var playerSpeedMultiplierMax: float = 3.0
var playerInvulnTimeMax: float = 5.0


var mainWeaponCooldownIncrease: float = -0.4
var mainWeaponHitMaxIncrease: int = 2
var mainWeaponDamageIncrease: float = 0.5
var mainWeaponSizeIncrease: float = 0.6
var playerSpeedMultiplierIncrease: float = 0.2
var playerInvulnTimeIncrease: float = 0.5

var playerXpScaleFactor: float = 1.0
var playerXpScaleFactorIncrease: float = -0.1
var playerXpScaleFactorMin: float = 0.1

signal xpBarFull
signal trashCanCreated
signal trashCanDeleted

signal attributeUpdated
signal disableButton

signal playerDied

signal musicOn
signal musicOff

enum ButtonType {
	PLAYERINVULNTIME,
	PLAYERSPEED,
	WEAPONCOOLDOWN,
	WEAPONDAMAGE,
	WEAPONHITMAX,
	WEAPONSCALE
}

var soundEnabled := true
var musicEnabled := true

func toggle_sound():
	soundEnabled = !soundEnabled


func toggle_music():
	musicEnabled = !musicEnabled
	if musicEnabled:
		musicOn.emit()
	else:
		musicOff.emit()
