extends LevelUpCard

func _take_action():
	Global.playerInvulnTimeIndex += 1
	if Global.playerInvulnTimeIndex + 1 == Global.playerInvulnTimeLevels.size():
		Global.disableButton.emit(Global.ButtonType.PLAYERINVULNTIME)
