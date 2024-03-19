extends LineEdit

func _ready():
	ClipboardControl.animationPlayerFade = get_parent().find_child("CopiedNotif").get_child(0)

func _on_text_submitted(new_text):
	self.visible = false
	if "text" in global.usingTextEdit:
		global.usingTextEdit.text = new_text
	if global.usingTextEdit.has_method("updateValues"):
		global.usingTextEdit.updateValues()
	elif global.usingTextEdit.get_parent().has_method("updateValues"):
		global.usingTextEdit.get_parent().updateValues()
	else:
		global.usingTextEdit = null
	self.text = ""

func _is_pos_in(checkpos:Vector2, gr):
	gr = gr.get_global_rect()
	return checkpos.x>=gr.position.x and checkpos.y>=gr.position.y and checkpos.x<gr.end.x and checkpos.y<gr.end.y
func _input(event):
	if event is InputEventMouseButton and not _is_pos_in(event.position,self) or event.is_action_pressed("ui_esc"):
		global.usingTextEdit = self
		_on_text_submitted("")


func _on_mouse_entered():
	global.hoveringGUI = true


func _on_mouse_exited():
	global.hoveringGUI = false
	
