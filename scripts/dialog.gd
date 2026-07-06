extends Control

@onready var speaker_label: Label = $VBoxContainer/Speaker
@onready var dialogue_label: RichTextLabel = $VBoxContainer/Dialogue
@onready var continue_button: Button = $Continue
var typing_speed = 20
var typing_time
var dialogue_queue = []
var is_dialogue_displayed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !dialogue_queue.is_empty() and !is_dialogue_displayed:
		display_line(dialogue_queue[0][0], dialogue_queue[0][1])

func display_line(line, speaker = ""):
	is_dialogue_displayed = true
	dialogue_label.bbcode_text = line
	speaker_label.text = speaker
	dialogue_label.visible_characters = 0
	typing_time = 0
	open()
	while dialogue_label.visible_characters < dialogue_label.get_total_character_count():
		typing_time += get_process_delta_time()
		dialogue_label.visible_characters = int(typing_time * typing_speed)
		await get_tree().process_frame
	continue_button.grab_focus()

func open():
	$AnimationPlayer.play("slide_in")

func close():
	$AnimationPlayer.play("slide_out")

func _on_continue_pressed():
	if dialogue_label.visible_characters < dialogue_label.get_total_character_count():
		typing_time = int(dialogue_label.get_total_character_count() / float(typing_speed) + 1)
	else:
		close()
		dialogue_queue.pop_front()
		
func add_to_queue(line, speaker = ""):
	dialogue_queue.append([line, speaker])


func _on_animation_player_animation_started(anim_name):
	if anim_name == "slide_in":
		get_parent().get_parent().find_child("Player")._set_movement_control_enabled(false)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "slide_out":
		is_dialogue_displayed = false
		if dialogue_queue.is_empty():
			get_parent().get_parent().find_child("Player")._set_movement_control_enabled(true)
