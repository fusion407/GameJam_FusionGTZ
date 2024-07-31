extends Control

@onready var pot: Pot = preload("res://Alchemy/Potions/craftable_potions.tres")
@onready var potInv : Pot = preload("res://Alchemy/Potions/potion_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()



@export var crafted_potion : PotItem = null


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





func _on_craft_button_gui_input(event):
	if Input.is_action_just_pressed("left_mouse") and event is InputEventMouseButton:
		potInv.insert(crafted_potion)
		



func _on_alchemy_craftables_slot_ui_1_select_potion(newPot):
	crafted_potion = newPot


func _on_alchemy_craftables_slot_ui_2_select_potion(newPot):
	crafted_potion = newPot


func _on_alchemy_craftables_slot_ui_3_select_potion(newPot):
	crafted_potion = newPot


func _on_alchemy_craftables_slot_ui_4_select_potion(newPot):
	crafted_potion = newPot


func _on_alchemy_craftables_slot_ui_5_select_potion(newPot):
	crafted_potion = newPot


func _on_alchemy_craftables_slot_ui_6_select_potion(newPot):
	crafted_potion = newPot


func _on_alchemy_craftables_slot_ui_7_select_potion(newPot):
	crafted_potion = newPot


func _on_alchemy_craftables_slot_ui_8_select_potion(newPot):
	crafted_potion = newPot


func _on_alchemy_craftables_slot_ui_9_select_potion(newPot):
	crafted_potion = newPot


func _on_alchemy_craftables_slot_ui_10_select_potion(newPot):
	crafted_potion = newPot


func _on_alchemy_craftables_slot_ui_11_select_potion(newPot):
	crafted_potion = newPot


func _on_alchemy_craftables_slot_ui_12_select_potion(newPot):
	crafted_potion = newPot
