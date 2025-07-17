extends CanvasLayer

@onready var xpBar := $xpBar
@onready var hpBar := $hpBar

@onready var musicButton := $MusicButton
@onready var soundButton := $SoundButton

var musicOn = preload("res://Assets/music_on.png")
var musicOff = preload("res://Assets/music_off.png")
var soundOn = preload("res://Assets/sound_on.png")
var soundOff = preload("res://Assets/sound_off.png")


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

func _process(_delta: float) -> void:
	xpBar.value = xp
	hpBar.value = hp


func _on_music_button_pressed() -> void:
	Global.toggle_music()
	musicButton.icon = musicOn if Global.musicEnabled else musicOff

func _on_sound_button_pressed() -> void:
	Global.toggle_sound()
	soundButton.icon = soundOn if Global.soundEnabled else soundOff
