extends Panel

@onready var pot: Pot = preload("res://Alchemy/Potions/craftable_potions.tres")
@onready var potInv : Pot = preload("res://Alchemy/Potions/potion_inventory.tres")
@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
var player = null

var mouse_is_hovered = false

signal selectPotion(newPot)

@onready var slots: Array = []

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
		
func update(slot: PotSlot):
	if !slot.pot:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.pot.texture

func _physics_process(delta):
	if mouse_is_hovered:
		self.modulate = Color("#ffffffcd")
	else:
		self.modulate = Color("ffffff")


func _on_mouse_detection_zone_mouse_entered():
	mouse_is_hovered = true


func _on_mouse_detection_zone_mouse_exited():
	mouse_is_hovered = false




func _on_mouse_detection_zone_input_event(viewport, event, shape_idx):

	# whenever potion is clicked and selected
	if event is InputEventMouseButton:
		var potionIndex = self.get_index()
		print("mouse button input work")
		
		# if slot is empty, return nothing
		if pot.slots[potionIndex].pot == null:
			return
			
		# create a variable for selected potion, change the nodes to selected potion
		var newPotion = pot.slots[potionIndex].pot
		var selected_potion = pot.slots[potionIndex].pot
		self.get_parent().get_parent().get_parent().find_child("potion_img").texture = selected_potion.texture
		self.get_parent().get_parent().get_parent().find_child("potion_title").text = selected_potion.name
		if !selected_potion:
			return
		selectPotion.emit(selected_potion)
		
		#DEBUG
		print(selected_potion.name)
		print(selected_potion.texture)

