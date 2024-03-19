extends CheckButton

func _ready():
	if FileAccess.file_exists("user://options.save"):
		var f = FileAccess.open("user://options.save", FileAccess.READ)
		var firstLine = f.get_line()
		self.button_pressed = firstLine == "true"
		print(firstLine == "true")
		print(firstLine)
	else:
		var saveOp = FileAccess.open("user://options.save", FileAccess.WRITE)
		saveOp.store_line(str(false))
	

func _on_toggled(toggled_on):
	var saveOp = FileAccess.open("user://options.save", FileAccess.WRITE)
	saveOp.store_line(str(toggled_on))
