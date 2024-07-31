extends CanvasLayer

var level_time
var hour_interval: float
var time_elapsed: float
var time_seconds
var displayHour
var displayMin
var amPM = "PM"
var inEnvironment: bool



# Called when the node enters the scene tree for the first time.
func _ready():
	inEnvironment = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	time_seconds = fmod(time_elapsed, 60)
	if (level_time - time_seconds) > delta: 
		updateTime()
	else:
		# game time will reset back to zero as transition starts, will make time 10 again otherwise
		inEnvironment = false
	

func updateTime():
	if inEnvironment:
		getHour(time_seconds)
		$Label.text = str(displayHour) + ":00 " + amPM
	else:
		$Label.text = "6:00 AM"
	

func getHour(gameTime):
	if gameTime < hour_interval:
		displayHour = 10
	elif gameTime < (hour_interval * 2):
		displayHour = 11
	elif gameTime < (hour_interval * 3):
		displayHour = 12
		amPM = "AM"
	elif gameTime < (hour_interval * 4):
		displayHour = 1
	elif gameTime < (hour_interval * 5):
		displayHour = 2
	elif gameTime < (hour_interval * 6):
		displayHour = 3
	elif gameTime < (hour_interval * 7):
		displayHour = 4
	elif gameTime < (hour_interval * 8):
		displayHour = 5
	
	


func _on_game_timer_has_time(time):
	level_time = time
	hour_interval = level_time / 8
	
