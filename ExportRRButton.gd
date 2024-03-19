extends Button

var dirDialogOpen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ClipboardControl.fileDir = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $FileDialog.visible:
		global.hoveringGUI = true
		global.directoryOpen = true
		dirDialogOpen = true
	elif dirDialogOpen:
		dirDialogOpen = false
		global.hoveringGUI = false
		global.directoryOpen = false


func _on_pressed():
	$FileDialog.popup()

func _on_file_dialog_file_selected(path):
	self.text = path
