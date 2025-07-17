extends LevelUpCard

func _take_action():
	Global.mainWeaponDamage += Global.mainWeaponDamageIncrease
	if Global.mainWeaponDamage >= Global.mainWeaponDamageMax:
		Global.disableButton.emit(Global.ButtonType.WEAPONDAMAGE)
