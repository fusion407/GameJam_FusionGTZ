extends Node2D

var isPlayerOnAlchemyTable = false
var tableIsBeingUsed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		isPlayerOnAlchemyTable = true
		$use_computer_label.visible = true
		


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		isPlayerOnAlchemyTable = false
		$use_computer_label.visible = false
