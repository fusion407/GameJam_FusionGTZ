extends Control

@onready var pot: Pot = preload("res://Alchemy/Potions/craftable_potions.tres")
@onready var potInv : Pot = preload("res://Alchemy/Potions/potion_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@export var crafted_potion : PotItem = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pot.update.connect(update_slots)
	potInv.update.connect(update_inv_slots)
	update_slots()
	update_inv_slots()
	
func update_slots():
	for i in range(min(pot.slots.size(), slots.size())):
		slots[i].update(pot.slots[i])

func update_inv_slots():
	for i in range(min(potInv.slots.size(), slots.size())):
		slots[i].update(potInv.slots[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_alchemy_craftables_slot_ui_1_select_potion(newPotion):
	crafted_potion = newPotion


func _on_alchemy_craftables_slot_ui_2_select_potion(newPotion):
	crafted_potion = newPotion


func _on_craft_button_gui_input(event):
	if event is InputEventMouseButton:
		potInv.insert(crafted_potion)
