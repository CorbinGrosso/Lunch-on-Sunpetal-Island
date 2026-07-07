extends Node

@onready var next_scene
@onready var next_scene_name
@onready var curr_scene_name = "bento_stand"
@onready var curr_scene = $BentoStand
@onready var prev_scene_name

@onready var anim = $AnimationPlayer
@onready var dialog = $UI/Dialog

# Called when the node enters the scene tree for the first time.
func _ready():
	dialog.position.y -= 120

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	pass
	
func _update_scene(destination):
	next_scene_name = destination
	if (curr_scene_name == "home" and destination == "bento_stand") or (curr_scene_name == "bento_stand" and destination == "dock"):
		$Player.velocity.x = $Player._get_speed()
	else:
		$Player.velocity.x = -$Player._get_speed()
	anim.play("fade_in")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		next_scene = load("res://scenes/" + next_scene_name + ".tscn").instantiate()
		next_scene.visible = false
		add_child(next_scene)
		curr_scene.queue_free()
		prev_scene_name = curr_scene_name
		curr_scene = next_scene
		curr_scene_name = next_scene_name
		curr_scene.visible = true
		anim.play("fade_out")
	elif anim_name == "fade_out":
		$Player._set_movement_control_enabled(true)

func _on_animation_player_animation_started(anim_name):
	if anim_name == "fade_out":
		if (prev_scene_name == "home" and curr_scene_name == "bento_stand") or (prev_scene_name == "bento_stand" and curr_scene_name == "dock"):
			$Player.position.x = $Player.get_left_start_pos()
		else:
			$Player.position.x = $Player.get_right_start_pos()
