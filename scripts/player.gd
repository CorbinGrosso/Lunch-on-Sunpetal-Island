extends CharacterBody2D

@export var flip_h = false
@export var player_sprite: AnimatedSprite2D

const SPEED = 150.0
var screen_size
var movement_control_enabled = true

func _ready():
	screen_size = get_viewport_rect().size
	player_sprite.flip_h = flip_h
	player_sprite.play()
	
func _physics_process(_delta):

	if movement_control_enabled:
		# if move_right and !move_left, direction is 1
		# if !move_right and move_left, direction is -1
		# if both move_right and move_left, direction is 0 and player does not move
		var direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		velocity.x = direction * SPEED

	if velocity.x != 0:
		player_sprite.animation = "walk"
		player_sprite.flip_h = velocity.x < 0
	else:
		player_sprite.animation = "default"
		
	move_and_slide()
	
func _set_movement_control_enabled(val):
	movement_control_enabled = val
	
func _get_movement_control_enabled():
	return movement_control_enabled
	
func _get_speed():
	return SPEED
