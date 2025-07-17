extends CanvasLayer

var overlay = preload("res://Scenes/UI/overlay.tscn")

func _ready():
	Global.playerDied.connect(_create_overlay)

func _create_overlay():
	var overlayInstance = overlay.instantiate()
	add_child(overlayInstance)
