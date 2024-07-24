extends Control

var is_open = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$NinePatchRect.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start():
	print("is working?")
	if is_open:
		return
	print("is working? now???")
	is_open = true
	$NinePatchRect.visible = true


func open():
	$NinePatchRect.visible = true
	is_open = true
	
func close():
	$NinePatchRect.visible = false
	is_open = false
