extends LevelUpCard

func _take_action():
	Global.mainWeaponDamageIndex += 1
	if Global.mainWeaponDamageIndex + 1 == Global.mainWeaponDamageLevels.size():
		Global.disableButton.emit(Global.ButtonType.WEAPONDAMAGE)
