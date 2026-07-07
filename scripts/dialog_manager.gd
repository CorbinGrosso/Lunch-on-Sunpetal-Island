extends Control

@onready var speaker_label: Label
@onready var dialogue_label: RichTextLabel
@onready var continue_button: Button
@onready var accept_button: Button
@onready var decline_button: Button
@onready var anim: AnimationPlayer
var typing_speed = 20
var typing_time
var dialogue_queue = []
var is_dialogue_displayed = false

func setup(speaker_label_, dialogue_label_, continue_button_, accept_button_, decline_button_, anim_):
	speaker_label = speaker_label_
	dialogue_label = dialogue_label_
	continue_button = continue_button_
	accept_button = accept_button_
	decline_button = decline_button_
	anim = anim_

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !dialogue_queue.is_empty() and !is_dialogue_displayed:
		_display_line(dialogue_queue[0][0], dialogue_queue[0][1], dialogue_queue[0][2])

func _display_line(line, speaker = "", is_transaction = false):
	is_dialogue_displayed = true
	dialogue_label.text = line
	speaker_label.text = speaker
	dialogue_label.visible_characters = 0
	typing_time = 0
	continue_button.visible = !is_transaction
	accept_button.visible = is_transaction
	decline_button.visible = is_transaction
	open()
	while dialogue_label.visible_characters < dialogue_label.get_total_character_count():
		typing_time += get_process_delta_time()
		dialogue_label.visible_characters = int(typing_time * typing_speed)
		await get_tree().process_frame
	continue_button.grab_focus()
	
func open():
	anim.play("slide_in")
	
func close():
	anim.play("slide_out")
	dialogue_queue.pop_front()

func _on_continue_pressed():
	if !_is_dialogue_done_typing():
		_force_dialogue_done_typing()
	else:
		close()
		
func add_to_queue(line, speaker: String = "", is_transaction: bool = false):
	dialogue_queue.append([line, speaker, is_transaction])
	
func _is_dialogue_done_typing():
	return dialogue_label.visible_characters >= dialogue_label.get_total_character_count()

func _force_dialogue_done_typing():
	typing_time = int(dialogue_label.get_total_character_count() / float(typing_speed) + 1)
