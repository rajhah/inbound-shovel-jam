extends CanvasLayer

@onready var xpBar := $xpBar
@onready var hpBar := $hpBar

@onready var musicButton := $MusicButton
@onready var soundButton := $SoundButton

var musicOn := preload("res://Assets/music_on.png")
var musicOff := preload("res://Assets/music_off.png")
var soundOn := preload("res://Assets/sound_on.png")
var soundOff := preload("res://Assets/sound_off.png")

var cycling := false
var hue := 0.0


var xp: int = 0:
	get:
		return xp
	set(value):
		xp = min(100, value)


var hp: int = 100:
	get:
		return hp
	set(value):
		hp = value

func _process(delta: float) -> void:
	xpBar.value = xp
	hpBar.value = hp

	if xpBar.value >= 100:
		if not cycling:
			cycling = true

		hue += .5 * delta
		if hue > 1.0:
			hue = 0.0

		xpBar.modulate = Color.from_hsv(hue, 1.0, 1.0)
	else:
		if cycling:
			cycling = false
			xpBar.modulate = Color("ffeb00")


func _on_music_button_pressed() -> void:
	Global.toggle_music()
	musicButton.icon = musicOn if Global.musicEnabled else musicOff

func _on_sound_button_pressed() -> void:
	Global.toggle_sound()
	soundButton.icon = soundOn if Global.soundEnabled else soundOff
