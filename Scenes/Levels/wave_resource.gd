extends Resource
class_name WaveResource

@export_range(0.1, 30.0) var delay: float = 8.0
@export_enum("normal", "circle") var spawn_type: String = "normal"
@export var enemies: Dictionary[PackedScene, int]
