extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var button = $Button

const BASE_TEXT = "[E] to "

var active_areas = []
var can_interact = true

func register_area(area: InteractionArea):
	active_areas.append(area)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
		
func _process(_delta):
	if !active_areas.is_empty() and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		button.text = active_areas[0].action_name
		button.position = active_areas[0].global_position
		button.position.y -=  36
		button.position.x -= button.size.x / 2
		button.show()
	else:
		button.hide()
		
func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	
func _input(event):
	if event.is_action_pressed("interact") and can_interact:
		if !active_areas.is_empty():
			can_interact = false
			button.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
