extends Button

@export var level: int

func _on_pressed() -> void:
	Global.closeDebugMenu.emit()
	Global.setCurrentLevel.emit(level - 1)
