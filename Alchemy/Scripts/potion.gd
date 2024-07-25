extends Resource

class_name Pot

signal update

@export var slots: Array[PotSlot]

func insert(potion: PotItem):
	var potionSlots = slots.filter(func(slot): return slot.potion == potion)
	if !potionSlots.is_empty():
		potionSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.potion == null)
		if !emptySlots.is_empty():
			emptySlots[0].potion = potion
			emptySlots[0].amount = 1
	update.emit()
