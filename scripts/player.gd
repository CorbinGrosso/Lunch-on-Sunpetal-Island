extends CharacterBody2D


const SPEED = 150.0
var screen_size
@export var flip_h = false
var movement_control_enabled = true

func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.flip_h = flip_h
	$AnimatedSprite2D.play()
	
func _physics_process(_delta):

	if movement_control_enabled:
		# if move_right and !move_left, direction is 1
		# if !move_right and move_left, direction is -1
		# if both move_right and move_left, direction is 0 and player does not move
		var direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		velocity.x = direction * SPEED

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "default"
		
	move_and_slide()
	
func _set_movement_control_enabled(val):
	movement_control_enabled = val
	
func _get_movement_control_enabled():
	return movement_control_enabled
