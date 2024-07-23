extends Node2D

var playerOnDoor = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if !playerOnDoor:
		return
	if event.is_action_pressed("chat"):
		print("game start?")
		$Fade_transition.show()
		$Fade_transition/fade_timer.start()
		$Fade_transition/AnimationPlayer.play("fade_in")
		

func _on_start_game_area_body_entered(body):
	if body.has_method("player"):
		playerOnDoor = true
		print("Click F to start game.")


func _on_start_game_area_body_exited(body):
	if body.has_method("player"):
		playerOnDoor = false
		print("or not.....")



func _on_fade_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")