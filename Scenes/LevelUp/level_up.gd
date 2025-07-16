extends CanvasLayer

@export var buttons: Array[PackedScene] = []

func _ready() -> void:
	Global.trashCanDeleted.connect(_level_up)

func _level_up():
	var copy = buttons.duplicate()
	copy.shuffle()
	var buttonsToSpawn = copy.slice(0, min(2, buttons.size()))

	for i in range(buttonsToSpawn.size()):
		var button_parent = buttonsToSpawn[i].instantiate()
		button_parent.position = Vector2(160 + (288 * i), 119)
		add_child(button_parent)
		button_parent.add_to_group("buttons")
