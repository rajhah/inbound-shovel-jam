extends Node2D

var audioPlayer: AudioStreamPlayer
var deathPlayer: AudioStreamPlayer

func _ready() -> void:
	audioPlayer = $player/MainMusicPlayer
	deathPlayer = $CanvasLayer/DeathMusicPlayer

	AudioServer.set_bus_effect_enabled(0, 0, false)

	Global.musicOn.connect(_music_on)
	Global.musicOff.connect(_music_off)
	Global.playerDied.connect(_player_died)

	Global.trashCanDeleted.connect(_trash_can_deleted)
	Global.attributeUpdated.connect(_attribute_updated)

	if Global.musicOn:
		audioPlayer.play( )

func _music_on():
	var tween = get_tree().create_tween()
	tween.tween_property(audioPlayer, "volume_db", 0.0, 0.3)

func _music_off():
	var tween = get_tree().create_tween()
	tween.tween_property(audioPlayer, "volume_db", -80.0, 0.3)

func _player_died():
	_music_off()
	if Global.musicEnabled:
		deathPlayer.play()

func _trash_can_deleted():
	AudioServer.set_bus_effect_enabled(0, 0, true)

func _attribute_updated():
	AudioServer.set_bus_effect_enabled(0, 0, false)
