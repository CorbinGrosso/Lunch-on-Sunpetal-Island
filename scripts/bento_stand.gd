extends Node2D

@onready var bento_stand_interaction_area: InteractionArea = $BentoStandInteractionArea

# Called when the node enters the scene tree for the first time.
func _ready():
	bento_stand_interaction_area.interact = Callable(self, "_on_bento_stand_interact")

func _on_bento_stand_interact():
	VillagerManager.open_shop()
