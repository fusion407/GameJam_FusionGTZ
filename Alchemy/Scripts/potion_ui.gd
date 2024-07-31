extends Control

@onready var pot: Pot = preload("res://Alchemy/Potions/potion_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

signal drinkPotion(potion, index)
var is_open = false
@onready var equipped_potion_index = 0
@onready var equipped_potions: Array = []
var activePotion

func _ready():

	slots[equipped_potion_index].modulate = Color("ffffff88")
	pot.update.connect(update_slots)
	update_slots()
	if !activePotion:
		activePotion = equipped_potions[equipped_potion_index]
	close()
	
func update_slots():
	for i in range(min(pot.slots.size(), slots.size())):
		slots[i].update(pot.slots[i])
		equipped_potions = pot.slots
	
	
func remove_potion(potion, index):
	print("work")
	pot.slots[index].amount = pot.slots[index].amount - 1
	if pot.slots[index].amount == 0:
		pot.slots[index].pot = null
	update_slots()

func _process(delta):
	if Input.is_action_just_pressed("i"):
		if is_open:
			close()
		else:
			open()
	if Input.is_action_just_pressed("q") and pot:
		toggle_potion()
	if Input.is_action_just_pressed("right_click"):
		useItem()
	
	if(activePotion.pot):
		$CanvasLayer/selected_potion_box/item_display.texture = activePotion.pot.texture
	else:
		$CanvasLayer/selected_potion_box/item_display.texture = null
	
func useItem():

	if activePotion.pot == null:
		print("No potion equipped")
	else:
		drinkPotion.emit(activePotion.pot, equipped_potion_index)

func toggle_potion():
	
	slots[equipped_potion_index].modulate = Color("ffffff")
	if equipped_potion_index <= 3 and equipped_potion_index >= 0:
		equipped_potion_index = equipped_potion_index + 1
		if equipped_potion_index == 4:
			equipped_potion_index = 0
	activePotion = equipped_potions[equipped_potion_index]
	slots[equipped_potion_index].modulate = Color("ffffff88")
	
	

		



func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false

