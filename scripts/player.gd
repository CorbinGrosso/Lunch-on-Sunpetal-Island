extends CharacterBody2D


const SPEED = 300.0
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play()
	
func _process(_delta):

	var direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = direction * SPEED

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "default"
		
		
	move_and_slide()
