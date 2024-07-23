extends Node2D

var button_type = null



func _on_start_pressed():
	button_type = "start"
	$Fade_transition.show()
	$Fade_transition/fade_timer.start()
	$Fade_transition/AnimationPlayer.play("fade_in")

func _on_options_pressed():
	# todo: create options scene and implement into main menu
	
	button_type = "options"
	$Fade_transition.show()
	$Fade_transition/Fade_timer.start()
	$Fade_transition/AnimationPlayer.play("fade_in")


func _on_quit_pressed():
	get_tree().quit()


func _on_fade_timer_timeout():
	if button_type == "start":
		get_tree().change_scene_to_file("res://Scenes/house.tscn")
	elif button_type == "options":
		get_tree().change_scene_to_file("res://Scenes/house.tscn")  # change the scene to options when the options scene is created
