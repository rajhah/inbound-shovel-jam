extends CanvasLayer

@onready var xpBar := $xpBar
@onready var hpBar := $hpBar

var xp: int = 0:
	get:
		return xp
	set(value):
		xp = value

var hp: int = 100:
	get:
		return hp
	set(value):
		hp = value


func _process(delta: float) -> void:
	xpBar.value = xp
	hpBar.value = hp
