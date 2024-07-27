extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Fade_transition.show()
	$Fade_transition/fade_timer.start()
	$Fade_transition/AnimationPlayer.play("fade_out")
	
	$Player.game_has_started = true
	
	


func _on_game_timer_timeout():
	print("timer run out. yay")
	$Fade_transition.show()
	$Fade_transition/fade_timer.start()
	$Fade_transition/AnimationPlayer.play("fade_in")
	await get_tree().create_timer(5)
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	

