extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.name == "TrashCanDetector":
		Global.healthPackDeleted.emit(-12)

	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", area.global_position, 0.25)
	tween.parallel().tween_property(self, "rotation", PI, 0.25)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.4)
	tween.tween_callback(_die)

func _die():
	call_deferred("queue_free")
