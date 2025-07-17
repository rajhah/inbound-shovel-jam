extends LevelUpCard

func _take_action():
	Global.playerSpeedMultiplier += Global.playerSpeedMultiplierIncrease
	if Global.playerSpeedMultiplier >= Global.playerSpeedMultiplierMax:
		Global.disableButton.emit(Global.ButtonType.PLAYERSPEED)
