extends Control
class_name Hotbar
@onready var pot: Pot = preload("res://Alchemy/Potions/potion_inventory.tres")
@onready var slots: Array = $NinePatchRect.get_children()
@onready var equipped_potion_index = 0
@onready var equipped_potions: Array = []



signal currentPot

var activePotion
# Called when the node enters the scene tree for the first time.
func _ready():
	pot.update.connect(update_slots)
	update_slots()
	
func update_slots():
	for i in range(min(pot.slots.size(), slots.size())):
		slots[i].update(pot.slots[i])
		equipped_potions = pot.slots

func toggle_potion():
	
	
	if equipped_potion_index <= 3 and equipped_potion_index >= 0:
		equipped_potion_index = equipped_potion_index + 1
		if equipped_potion_index == 4:
			equipped_potion_index = 0
	print(currentPot)

	var newTexture = equipped_potions[equipped_potion_index]


	currentPot.emit(equipped_potion_index)


	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("q") and pot:
		toggle_potion()
	if Input.is_action_just_pressed("right_click"):
		print(activePotion)


func _on_hot_bar_item_signal(item_visual):
	print("test:")
	print(item_visual)
	if !item_visual.texture: 
		return

