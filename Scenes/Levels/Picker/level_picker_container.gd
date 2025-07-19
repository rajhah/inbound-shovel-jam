extends CanvasLayer

var menuActive = false
@onready var levelPicker = $LevelPicker

func _ready() -> void:
	Global.closeDebugMenu.connect(_close_debug_menu)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Debug Menu"):
		_toggle_debug_menu()

func _close_debug_menu():
	menuActive = true
	_toggle_debug_menu()

func _toggle_debug_menu():
	var tween = get_tree().create_tween()
	if menuActive:
		tween.tween_property(levelPicker, "position:y", 658.0, 0.1)
		menuActive = false
	else:
		tween.tween_property(levelPicker, "position:y", 0.0, 0.1)
		menuActive = true
