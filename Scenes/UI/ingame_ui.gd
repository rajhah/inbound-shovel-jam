extends CanvasLayer

@onready var xpBar := $xpBar
@onready var hpBar := $hpBar

@onready var musicButton := $MusicButton
@onready var soundButton := $SoundButton

var audioPlayer: AudioStreamPlayer
var deathPlayer: AudioStreamPlayer
var levelInfo: RichTextLabel

var musicOn := preload("res://Assets/music_on.png")
var musicOff := preload("res://Assets/music_off.png")
var soundOn := preload("res://Assets/sound_on.png")
var soundOff := preload("res://Assets/sound_off.png")

var bus_index: int

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

func _ready() -> void:
	audioPlayer = $"../player/MainMusicPlayer"
	deathPlayer = $"../CanvasLayer/DeathMusicPlayer"
	levelInfo = $RichTextLabel

	Global.musicOn.connect(_music_on)
	Global.musicOff.connect(_music_off)
	Global.playerDied.connect(_player_died)

	Global.currentWave.connect(_set_current_wave_message)

	if Global.musicOn:
		audioPlayer.play( )

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

func _music_on():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(audioPlayer, "volume_db", 0.0, 0.3)

func _music_off():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(audioPlayer, "volume_db", -80.0, 0.3)

func _player_died():
	_music_off()
	if Global.musicEnabled:
		deathPlayer.play()

func _set_current_wave_message(level: int, nLevel: int, wave: int, nWave: int):
	levelInfo.text = "[font_size=18][color=gold][b]  LEVEL[/b][/color] [color=white]%d[/color][color=gray]/%d[/color] [color=cyan]•[/color] [color=orange][b]WAVE[/b][/color] [color=white]%d[/color][color=gray]/%d[/color][/font_size]" % [level, nLevel, wave, nWave]
