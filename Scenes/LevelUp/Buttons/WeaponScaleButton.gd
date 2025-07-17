extends LevelUpCard

func _take_action():
	Global.mainWeaponSize += Global.mainWeaponSizeIncrease
	if Global.mainWeaponSize >= Global.mainWeaponSizeMax:
		Global.disableButton.emit(Global.ButtonType.WEAPONSCALE)
