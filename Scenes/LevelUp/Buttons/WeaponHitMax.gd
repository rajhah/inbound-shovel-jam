extends LevelUpCard

func _take_action():
	Global.mainWeaponHitMax += Global.mainWeaponHitMaxIncrease
	if Global.mainWeaponHitMax >= Global.mainWeaponHitMaxTargets:
		Global.disableButton.emit(Global.ButtonType.WEAPONHITMAX)
