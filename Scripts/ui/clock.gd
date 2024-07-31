#-----------------------------------------------------------------------------------------------
# clock.gd
# Author: Corbin McKay
# script to display in game clock during wizards nightly quest from 10pm-6am
# a signal is received from the game timer to receive the total set time for 
# the level. Hour intervals are calculated by taking the total time divided by 8
# current time in the nightly quest is calculated using delta and converted to seconds
# the hour is updated after elapsed time goes up by each set interval. 
# even if the level time is changed, the functionality remains the same.
#-----------------------------------------------------------------------------------------------

extends CanvasLayer

var level_time     # time the level will last
var hour_interval: float     # how many real seconds for each in game hour
var time_elapsed: float      # elapsed time

# variables to hold and display in game time
var displayHour
var displayMin
var amPM = "PM"

# signals to send to lighting scene, to tell which light layer to use
signal light1
signal light2
signal light3
signal light4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# gets current time elapsed and calls to check if time is to be updated every frame
func _process(delta):
	time_elapsed += delta
	updateTime()

# checks for time update and writes the current time to the label
func updateTime():
	getHour(time_elapsed)
	$Label.text = str(displayHour) + ":00 " + amPM

	
# if elif hell, check when game time passes each hour interval
func getHour(gameTime):
	if gameTime < hour_interval:
		displayHour = 10
		light1.emit()
	elif gameTime < (hour_interval * 2):
		displayHour = 11
		light2.emit()
	elif gameTime < (hour_interval * 3):
		displayHour = 12
		amPM = "AM"
		light3.emit()
	elif gameTime < (hour_interval * 4):
		displayHour = 1
		light4.emit()
	elif gameTime < (hour_interval * 5):
		displayHour = 2
	elif gameTime < (hour_interval * 6):
		displayHour = 3
		light3.emit()
	elif gameTime < (hour_interval * 7):
		displayHour = 4
		light2.emit()
	elif gameTime < (hour_interval * 8):
		displayHour = 5
		light1.emit()
	else: 
		displayHour = 6
	

# runs when game timer signals, passing the wait time (total level time)
func _on_game_timer_has_time(time):
	level_time = time
	hour_interval = level_time / 8
	
