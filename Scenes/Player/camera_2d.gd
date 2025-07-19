extends Camera2D
var shaking := false
var intensity := 1.0
var intensityTween: Tween

func _ready() -> void:
	global_rotation = 0.0

func shake():
	shaking = true
	intensityTween = get_tree().create_tween()
	intensityTween.tween_property(self, "intensity", 0.0, 0.3)
	intensityTween.tween_callback(_end_shake)

func _end_shake():
	shaking = false
	intensity = 1.0
	intensityTween.kill()
	offset = Vector2.ZERO
	global_rotation = 0.0


func _process(delta: float) -> void:
	if shaking:
		var _r1 = randf_range(-10, 10)
		var _r2 = randf_range(-10, 10)
		var _r3 = randf_range(-10, 10)

		offset = Vector2(_r1 * intensity, _r2 * intensity)
		global_rotation = deg_to_rad(_r3 * intensity)
	else:
		#this is scuffed but it works
		global_rotation = 0.0
