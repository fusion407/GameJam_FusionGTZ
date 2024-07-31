extends Panel


@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var inv : Inv = preload("res://Inventory/player_inventory.tres")
@onready var slots: Array = []
var itemIndex
var selected_item
var mouse_is_hovered = false


func _ready():
	inv.update.connect(update_slots)
	update_slots()

	
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func update(slot: InvSlot):
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		if slot.amount > 1:
			amount_text.visible = true
		amount_text.text = str(slot.amount)


func _physics_process(delta):
	if mouse_is_hovered:
		self.modulate = Color("#ffffffcd")
		itemIndex = self.get_index()
		
		# if slot is empty, return nothing
		if inv.slots[itemIndex].item == null:
			return
			
		selected_item = inv.slots[itemIndex].item
		$CanvasLayer/Label.text = selected_item.name
		
	else:
		self.modulate = Color("ffffff")
		$CanvasLayer/Label.text = ""



func _on_mouse_detection_zone_mouse_entered():
	mouse_is_hovered = true

func _on_mouse_detection_zone_mouse_exited():
	mouse_is_hovered = false

