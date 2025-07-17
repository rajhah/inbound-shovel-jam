extends TextureRect

var textOverlay: TextureRect
var restartButton: Button

func _ready() -> void:
	textOverlay = $TextOverlay
	restartButton = $Button

	_overlay_on()

func _overlay_on():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	tween.tween_callback(_text_on)

func _text_on():
	await get_tree().create_timer(0.5).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(textOverlay, "modulate:a", 1.5, 1)
	tween.tween_callback(_button_on)

func _button_on():
	await get_tree().create_timer(1.5).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(restartButton, "modulate:a", 0.5, 1)
	tween.tween_callback(_enable_button)

func _enable_button():
	restartButton.disabled = false

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
