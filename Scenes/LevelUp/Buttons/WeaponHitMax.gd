extends LevelUpCard

func _take_action():
	Global.mainWeaponTargetsIndex += 1
	if Global.mainWeaponTargetsIndex + 1 == Global.mainWeaponTargetsLevels.size():
		Global.disableButton.emit(Global.ButtonType.WEAPONHITMAX)
