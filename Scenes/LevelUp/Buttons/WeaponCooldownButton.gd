extends LevelUpCard

func _take_action():
	Global.mainWeaponCooldownIndex += 1
	if Global.mainWeaponCooldownIndex + 1 == Global.mainWeaponCooldownLevels.size():
		Global.disableButton.emit(Global.ButtonType.WEAPONCOOLDOWN)
