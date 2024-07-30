extends Control

@onready var pot: Pot = preload("res://Alchemy/Potions/potion_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()


var is_open = false
@onready var equipped_potion_index = 0
@onready var equipped_potions: Array = []
var activePotion

func _ready():

	slots[equipped_potion_index].modulate = Color("ffffff11")
	pot.update.connect(update_slots)
	update_slots()
	if !activePotion:
		activePotion = equipped_potions[equipped_potion_index]
	close()
	
func update_slots():
	for i in range(min(pot.slots.size(), slots.size())):
		slots[i].update(pot.slots[i])
		equipped_potions = pot.slots
	
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

func useItem():
	print("used item")
	if activePotion.pot == null:
		print("no potion")
	else:
		print("yes potion")
		print(activePotion.pot.texture)

func toggle_potion():
	
	slots[equipped_potion_index].modulate = Color("ffffff")
	if equipped_potion_index <= 3 and equipped_potion_index >= 0:
		equipped_potion_index = equipped_potion_index + 1
		if equipped_potion_index == 4:
			equipped_potion_index = 0
	activePotion = equipped_potions[equipped_potion_index]
	slots[equipped_potion_index].modulate = Color("ffffff11")
	
	print("active potion:")
	print(activePotion.pot)
	
	if(activePotion.pot):
		$CanvasLayer/selected_potion_box/item_display.texture = activePotion.pot.texture
	else:
		$CanvasLayer/selected_potion_box/item_display.texture = null
		



func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false

