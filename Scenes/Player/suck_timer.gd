extends Timer

func _process(_delta: float) -> void:
	if wait_time != Global.mainWeaponCooldown:
		wait_time = Global.mainWeaponCooldown
