extends Resource

class_name PotItem

@export var name: String = ""
@export var texture: Texture2D


func _ready():
	pass


func drink_healing_pot(player: Player) -> void:
	print(player.health)
	
