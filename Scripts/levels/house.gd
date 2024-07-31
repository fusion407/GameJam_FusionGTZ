extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Fade_transition.show()
	$Fade_transition/fade_timer.start()
	$Fade_transition/AnimationPlayer.play("fade_out")
	
	$Player.health = 1000
	$Player.isAlive = true
	$Player.game_has_started = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
