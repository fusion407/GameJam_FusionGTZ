extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display

func update(slot: PotSlot):
	if !slot.pot:
		item_visual.visible = false

	else:
		item_visual.visible = true
		item_visual.texture = slot.pot.texture
