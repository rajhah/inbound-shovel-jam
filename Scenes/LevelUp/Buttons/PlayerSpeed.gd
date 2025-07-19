extends LevelUpCard

func _take_action():
	Global.playerSpeedMultiplierIndex += 1
	if Global.playerSpeedMultiplierIndex + 1 == Global.playerSpeedMultiplierLevels.size():
		Global.disableButton.emit(Global.ButtonType.PLAYERSPEED)
