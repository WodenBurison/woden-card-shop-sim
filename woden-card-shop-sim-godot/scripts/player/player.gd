extends CharacterBody2D

@export var speed: float = 240.0

@onready var sprite: Sprite2D = $Sprite2D

var last_direction: Vector2 = Vector2.DOWN

func _physics_process(_delta: float) -> void:
	var input_vector := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	velocity = input_vector * speed
	move_and_slide()

	if input_vector != Vector2.ZERO:
		last_direction = input_vector
		# Placeholder for animation state later, e.g.:
		# _update_facing_animation(last_direction)
