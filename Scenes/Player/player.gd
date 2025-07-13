extends CharacterBody2D

var rightHold: bool
var leftHold: bool
var upHold: bool
var downHold: bool

var maxSpeed = 100
var direction: Vector2:
	get:
		return direction.normalized()

var mousePosition

func _ready() -> void:
	add_to_group("player")

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())

func _physics_process(_delta: float) -> void:
	rightHold = Input.is_action_pressed("right")
	leftHold = Input.is_action_pressed("left")
	upHold = Input.is_action_pressed("up")
	downHold = Input.is_action_pressed("down")

	if rightHold:
		direction.x = 1
	elif leftHold:
		direction.x = -1
	else:
		direction.x = 0

	if upHold:
		direction.y = -1
	elif downHold:
		direction.y = 1
	else:
		direction.y = 0

	velocity = maxSpeed * direction.normalized()

	move_and_slide()
