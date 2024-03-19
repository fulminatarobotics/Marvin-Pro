extends PanelContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.KC:
		visible = true
	else:
		visible = false
