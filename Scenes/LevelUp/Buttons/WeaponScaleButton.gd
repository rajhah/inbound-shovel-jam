extends LevelUpCard

func _take_action():
	Global.mainWeaponSizeIndex += 1
	if Global.mainWeaponSizeIndex + 1 == Global.mainWeaponSizeLevels.size():
		Global.disableButton.emit(Global.ButtonType.WEAPONSCALE)
