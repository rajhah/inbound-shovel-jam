extends LevelUpCard

func _take_action():
	Global.playerInvulnTime += Global.playerInvulnTimeIncrease
	if Global.playerInvulnTime >= Global.playerInvulnTimeMax:
		Global.disableButton.emit(Global.ButtonType.PLAYERINVULNTIME)
