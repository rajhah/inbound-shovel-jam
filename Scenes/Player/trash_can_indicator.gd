extends Node2D

var spr: Sprite2D
var offset: Node2D
var player: CharacterBody2D
var target: Vector2 = Vector2.ZERO

func _ready() -> void:
	Global.trashCanCreated.connect(_on_trash_can_created)
	Global.trashCanDeleted.connect(_on_trash_can_deleted)
	spr = $Offset/Sprite2D
	offset = $Offset
	player = get_tree().get_first_node_in_group("player")

	_on_trash_can_deleted()

func _process(_delta: float) -> void:
	if !player:
		return

	global_position = player.global_position
	var direction = (target - global_position).normalized()
	rotation = direction.angle() + deg_to_rad(90)
	spr.rotation = -direction.angle() - deg_to_rad(90)

	if target != Vector2.ZERO:
		var distance = player.global_position.distance_to(target)
		if distance < 180:
			offset.position.y = max(-130, -distance + 50)


func _on_trash_can_created(trashCan: Area2D):
	offset.visible = true
	target = trashCan.global_position

func _on_trash_can_deleted():
	offset.visible = false
	offset.position.y = -130.0
	target = Vector2.ZERO
