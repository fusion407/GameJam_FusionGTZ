extends Control

@onready var pot: Pot = preload("res://Alchemy/Potions/Craftable Slots/craftable_potions.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	pot.update.connect(update_slots)
	update_slots()
	
func update_slots():
	for i in range(min(pot.slots.size(), slots.size())):
		slots[i].update(pot.slots[i])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
