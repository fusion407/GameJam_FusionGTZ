extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Fade_transition.show()
	$Fade_transition/fade_timer.start()
	$Fade_transition/AnimationPlayer.play("fade_out")
	
	$Player.game_has_started = true
	
	


func _on_game_timer_timeout():
	print("timer run out. yay")
	
