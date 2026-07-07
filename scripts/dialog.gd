extends Control

@onready var speaker_label: Label = $VBoxContainer/Speaker
@onready var dialogue_label: RichTextLabel = $VBoxContainer/Dialogue
@onready var continue_button: Button = $Continue
@onready var accept_button: Button = $Accept
@onready var decline_button: Button = $Decline
@onready var anim = $AnimationPlayer
@onready var player = get_parent().get_parent().find_child("Player")

func _ready():
	DialogManager.setup(speaker_label, dialogue_label, continue_button, accept_button, decline_button, anim)

func _on_continue_pressed():
	DialogManager._on_continue_pressed()

func _on_animation_player_animation_started(anim_name):
	if anim_name == "slide_in":
		player._set_movement_control_enabled(false)
		player.stop_moving()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "slide_out":
		DialogManager.is_dialogue_displayed = false
		if DialogManager.dialogue_queue.is_empty():
			player._set_movement_control_enabled(true)

func _on_accept_pressed():
	if !DialogManager._is_dialogue_done_typing():
		DialogManager._force_dialogue_done_typing()
	else:
		VillagerManager.accept_offer()
		DialogManager.close()

func _on_decline_pressed():
	if !DialogManager._is_dialogue_done_typing():
		DialogManager._force_dialogue_done_typing()
	else:
		VillagerManager.decline_offer()
		DialogManager.close()
