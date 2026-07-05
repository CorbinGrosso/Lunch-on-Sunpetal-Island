extends Area2D

@export var next_scene: String


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if body._get_movement_control_enabled():
		body._set_movement_control_enabled(false)
		get_parent().get_parent()._update_scene(next_scene)
