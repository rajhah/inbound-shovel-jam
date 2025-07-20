extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.name == "TrashCanDetector":
		Global.trashCanDeleted.emit()
		call_deferred("queue_free")
