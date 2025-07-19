extends CanvasLayer

var buttons: Dictionary = {
	Global.ButtonType.PLAYERINVULNTIME: preload("res://Scenes/LevelUp/Buttons/PlayerInvulnTime.tscn"),
	Global.ButtonType.PLAYERSPEED: preload("res://Scenes/LevelUp/Buttons/PlayerSpeed.tscn"),
	Global.ButtonType.WEAPONCOOLDOWN: preload("res://Scenes/LevelUp/Buttons/WeaponCooldownButton.tscn"),
	Global.ButtonType.WEAPONDAMAGE: preload("res://Scenes/LevelUp/Buttons/WeaponDamage.tscn"),
	Global.ButtonType.WEAPONHITMAX: preload("res://Scenes/LevelUp/Buttons/WeaponHitMax.tscn"),
	Global.ButtonType.WEAPONSCALE: preload("res://Scenes/LevelUp/Buttons/WeaponScaleButton.tscn")
	}

var disabledButtons: Dictionary = {}

func _ready() -> void:
	Global.trashCanDeleted.connect(_level_up)
	Global.disableButton.connect(_disable_button)

func _level_up():
	var available = _get_available_buttons()
	if available.is_empty():
		Global.maxLevelReached.emit()
		return

	available.shuffle()
	var buttonsToSpawn = available.slice(0, min(3, available.size()))

	for i in range(buttonsToSpawn.size()):
		var button_scene = buttons[buttonsToSpawn[i]]
		var button = button_scene.instantiate()
		button.position = Vector2(160 + (288 * i), 119)
		add_child(button)
		button.add_to_group("buttons")

	get_tree().paused = true

func _get_available_buttons() -> Array:
	var available = []
	for button_type in buttons.keys():
		if not button_type in disabledButtons:
			available.append(button_type)

	return available

func _disable_button(buttonType: Global.ButtonType):
	disabledButtons[buttonType] = true
