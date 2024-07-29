extends Resource

class_name Pot

signal update

@export var slots: Array[PotSlot]

func insert(potion: PotItem):
	var potionSlots = slots.filter(func(slot): return slot.pot == potion)
	if !potionSlots.is_empty():
		potionSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.pot == null)
		if !emptySlots.is_empty():
			emptySlots[0].pot = potion
			emptySlots[0].amount = 1
	update.emit()
