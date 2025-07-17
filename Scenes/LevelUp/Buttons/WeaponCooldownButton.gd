extends LevelUpCard

func _take_action():
	Global.mainWeaponCooldown += Global.mainWeaponCooldownIncrease
	if Global.mainWeaponCooldown <= Global.mainWeaponCooldownMax:
		Global.disableButton.emit(Global.ButtonType.WEAPONCOOLDOWN)
