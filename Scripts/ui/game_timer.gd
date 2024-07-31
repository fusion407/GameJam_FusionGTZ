extends Timer

var waitTime

signal hasTime(number)

# Called when the node enters the scene tree for the first time.
func _ready():
	waitTime = self.get_wait_time()
	print(waitTime)
	hasTime.emit(waitTime)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_clock_gimme_time():
	var target_node = get_node("res://Scripts/ui/clock.gd")
	target_node.receive_play_time(waitTime)
