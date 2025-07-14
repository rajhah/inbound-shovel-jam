extends Enemy

func die():
	Global.BossDefeated.emit()
	queue_free()
