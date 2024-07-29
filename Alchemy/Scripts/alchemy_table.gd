extends Node2D

var player
var player_in_table_zone = false
var is_using = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if 	player_in_table_zone:		
		if Input.is_action_just_pressed("e"):
			print("opened alchemy table")
			$CanvasLayer/alchemy_ui.start()
			is_using = true

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player_in_table_zone = true
		$use_computer_label.visible = true

		


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		player_in_table_zone = false
		$use_computer_label.visible = false
		if is_using:
			$CanvasLayer/alchemy_ui.close()
