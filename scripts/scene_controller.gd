extends Node

@onready var next_scene
@onready var next_scene_name
@onready var curr_scene_name = "bento_stand"
@onready var curr_scene = $BentoStand

@onready var anim: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
	
func _update_scene(destination):
	next_scene_name = destination
	anim.play("fade_in")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		next_scene = load("res://scenes/" + next_scene_name + ".tscn").instantiate()
		next_scene.visible = false
		add_child(next_scene)
		curr_scene.queue_free()
		curr_scene = next_scene
		curr_scene_name = next_scene_name
		curr_scene.visible = true
		anim.play("fade_out")
		
		 
