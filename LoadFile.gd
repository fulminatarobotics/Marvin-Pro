extends Button

var dirDialogOpen = false

const botScene = preload("res://bot.tscn")

var loadOnStart = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ControlZ.loadFile = self
	
	if FileAccess.file_exists("user://lastPath.yaml") and FileAccess.file_exists("user://options.save"):
		var f = FileAccess.open("user://options.save", FileAccess.READ)
		var firstLine = f.get_line()
		if firstLine == "true":
			loadOnStart = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if loadOnStart:
		_on_file_dialog_file_selected("user://lastPath.yaml")
		loadOnStart = false
	
	if $FileDialog.visible:
		global.hoveringGUI = true
		global.directoryOpen = true
		dirDialogOpen = true
	elif dirDialogOpen:
		dirDialogOpen = false
		global.hoveringGUI = false
		global.directoryOpen = false
	
	if Input.is_action_pressed("ui_q") and self.text == "STOP PREVIEW":
		self.text = "Load File..."
		


func _on_pressed():
	$FileDialog.popup()


func _on_file_dialog_file_selected(path):
	if ".yaml" in path:
		global.loadingFile = true
		if global.isPreviewing:
			global.previewBot.stopPreview()
		ControlZ.loadFileString = path
		$"../deleteAll"._on_yes_delete_but_pressed()
		var f = FileAccess.open(path, FileAccess.READ)
		var firstLine = f.get_line()
		var xDim = ""
		var yDim = ""
		var zDim = ""
		var allDims = [xDim,yDim,zDim]
		var startDim = 0
		if firstLine[0] == '#':
			for char in firstLine:
				if char.is_valid_int() or char == '.':
					allDims[startDim] += char
				if char == ',':
					startDim +=1
			global.botDimentions = Vector3(float(allDims[0]),float(allDims[1]),float(allDims[2]))
		
		var validNums = []
		while not f.eof_reached(): # iterate through all lines until the end of file is reached
			var line = f.get_line()
			var floatConvert = ""
			for char in line:
				if char.is_valid_int() or char == '.' or char == '-':
					floatConvert += char
			if floatConvert.is_valid_float():
				validNums.append(float(floatConvert))
		while len(validNums) >= 4:
			print(validNums[0]," ",validNums[1], " ", validNums[2], " ",validNums[3])
			var instanceBot = botScene.instantiate()
			instanceBot.position = Vector3(-validNums[1]/12.0,global.botDimentions.y/2.0,-validNums[0]/12.0)
			instanceBot.rotation.y = validNums[2]
			get_tree().get_root().add_child(instanceBot)
			instanceBot.find_child("TangentMover").rotation.y = validNums[3]
			instanceBot.stopFirstClick()
			global.botOrder.append(instanceBot)
			validNums.remove_at(0)
			validNums.remove_at(0)
			validNums.remove_at(0)
			validNums.remove_at(0)
		f.close()
		
		global.resetColors = true
		await get_tree().create_timer(1.0).timeout
		global.resetColors = false
		global.loadingFile = false
