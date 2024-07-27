extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Fade_transition.show()
	$Fade_transition/fade_timer.start()
	$Fade_transition/AnimationPlayer.play("fade_out")
	
	$Player.game_has_started = true
	$Player.isAlive = true
	
	


func _on_game_timer_timeout():
	print("timer run out. yay")
	$Player.game_has_started = false
	$Fade_transition/fade_timer.start()
	$Fade_transition/AnimationPlayer.play("fade_in")
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://Scenes/levels/main_menu.tscn")
	

