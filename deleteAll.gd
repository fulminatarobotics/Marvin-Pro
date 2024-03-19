extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_r") and !global.hoveringGUI:
		self.visible = true
	if self.visible == true:	
		global.hoveringGUI = true
	

func _on_yes_delete_but_pressed():
	ControlZ.actions.append(["loadedFile"])
	if !ControlZ.comingFromRedo:
		ControlZ.resetRedo()
	ControlZ.comingFromRedo = false
	var saveControlZ = ControlZ.actions[len(ControlZ.actions)-1]
	if ControlZ.loadFileString != "":
		saveControlZ.append(ControlZ.loadFileString)
		ControlZ.loadFileString = ""
	else:
		saveControlZ.append("")
	for bot in global.botOrder:
		saveControlZ.append([bot.position.x,bot.position.z,bot.rotation.y,bot.find_child("TangentMover").rotation.y,global.botOrder.find(bot),bot.returnOrder()])
	
	global.botOrder.clear()
	global.invisBots = false
	self.visible = false
	global.hoveringGUI = false



func _on_no_keep_but_pressed():
	self.visible = false
	global.hoveringGUI = false
