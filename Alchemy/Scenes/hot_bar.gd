extends Panel


@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label

signal itemSignal(item_visual)

func update(slot: PotSlot):
	if !slot.pot:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.pot.texture
		if slot.amount > 1:
			amount_text.visible = true
		amount_text.text = str(slot.amount)
	itemSignal.emit(item_visual)
