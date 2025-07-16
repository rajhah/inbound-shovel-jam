extends Button

class_name LevelUpCard

func _on_pressed() -> void:
	_take_action()
	call_deferred("_clear_buttons")

func _clear_buttons():
	for button in get_tree().get_nodes_in_group("buttons"):
		button.queue_free()

func _take_action():
	pass
