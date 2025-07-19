extends CanvasLayer

@onready var xpBar := $xpBar
@onready var hpBar := $hpBar

@onready var musicButton := $MusicButton
@onready var soundButton := $SoundButton

var audioPlayer: AudioStreamPlayer2D
var deathPlayer: AudioStreamPlayer2D

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

	bus_index = AudioServer.get_bus_index("Master")
	var effect = AudioEffectLowPassFilter.new()
	effect.cutoff_hz = 2000
	effect.db = AudioEffectFilter.FILTER_6DB
	effect.resonance = 0.5
	AudioServer.add_bus_effect(bus_index, effect)
	_attribute_updated()

	Global.musicOn.connect(_music_on)
	Global.musicOff.connect(_music_off)
	Global.playerDied.connect(_player_died)

	Global.trashCanDeleted.connect(_trash_can_deleted)
	Global.attributeUpdated.connect(_attribute_updated)

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

func _trash_can_deleted():
	AudioServer.set_bus_effect_enabled(bus_index, 0, true)

func _attribute_updated():
	AudioServer.set_bus_effect_enabled(bus_index, 0, false)
