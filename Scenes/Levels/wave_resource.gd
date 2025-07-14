extends Resource
class_name WaveResource

@export var delay: float
@export_enum("normal", "circle") var spawn_type: String
@export var enemies: Dictionary[PackedScene, int]
@export_enum("timer", "defeat") var endWaveTrigger: String = "timer"
