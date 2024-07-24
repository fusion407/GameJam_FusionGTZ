extends Control

var is_open = false
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start():
	if is_open:
		return
	is_open = true
	self.visible = true


func open():
	self.visible = true
	is_open = true
	
func close():
	self.visible = false
	is_open = false
