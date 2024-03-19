extends CanvasLayer

var foldedIn = false

@onready var animationPlayer = $"../AnimationPlayer"

var mouseOverSlider = false

func _ready():
	animationPlayer.play_backwards("foldAway")


func _process(delta):
	$WidthSelection.value = global.botDimentions.x
	$LengthSelection.value = global.botDimentions.z
	$HeightSelection.value = global.botDimentions.y
	
	if global.openedInstructions:
		$ScrollContainer.visible = false
	else:
		$ScrollContainer.visible = true
	
func _on_width_selection_value_changed(value):
	global.botDimentions.x = value


func _on_length_selection_value_changed(value):
	global.botDimentions.z = value


func _on_height_selection_value_changed(value):
	global.botDimentions.y = value
	

	
func _is_pos_in(checkpos:Vector2, gr):
	gr = gr.get_global_rect()
	return checkpos.x>=gr.position.x and checkpos.y>=gr.position.y and checkpos.x<gr.end.x and checkpos.y<gr.end.y
func _input(event):
	if event is InputEventMouseButton and not _is_pos_in(event.position,$WidthSelection) or event.is_action_pressed("ui_accept"):
		$WidthSelection.get_line_edit().release_focus()
	if event is InputEventMouseButton and not _is_pos_in(event.position,$LengthSelection) or event.is_action_pressed("ui_accept"):
		$LengthSelection.get_line_edit().release_focus()
	if event is InputEventMouseButton and not _is_pos_in(event.position,$HeightSelection) or event.is_action_pressed("ui_accept"):
		$HeightSelection.get_line_edit().release_focus()
	if event is InputEventMouseButton and not _is_pos_in(event.position,$SnappedSelection) or event.is_action_pressed("ui_accept"):
		$SnappedSelection.get_line_edit().release_focus()
	if event is InputEventMouseButton and not _is_pos_in(event.position,$CheckButton) or event.is_action_pressed("ui_accept"):
		$CheckButton.release_focus()
	if event is InputEventMouseButton and not _is_pos_in(event.position,$CheckButton2) or event.is_action_pressed("ui_accept"):
		$CheckButton2.release_focus()
	if event is InputEventMouseButton and not _is_pos_in(event.position,$CheckButton3) or event.is_action_pressed("ui_accept"):
		$CheckButton3.release_focus()
	if event is InputEventMouseButton and not _is_pos_in(event.position,$ExportRRButton) or event.is_action_pressed("ui_accept"):
		$ExportRRButton.release_focus()
	if event is InputEventMouseButton and not _is_pos_in(event.position,$LoadFileButton) or event.is_action_pressed("ui_accept"):
		$LoadFileButton.release_focus()
		
	if event is InputEventMouse and _is_pos_in(event.position,$MouseStuff):
		global.hoveringGUI = true
		mouseOverSlider = true
	elif mouseOverSlider == true:
		global.hoveringGUI = false
		mouseOverSlider = false


func _on_scroll_container_mouse_entered():
	global.hoveringGUI = true

func _on_scroll_container_mouse_exited():
	global.hoveringGUI = false

func _on_settings_mouse_entered():
	if !foldedIn:
		global.hoveringGUI = true

func _on_settings_mouse_exited():
	global.hoveringGUI = false


func _on_snapped_selection_value_changed(value):
	global.snappedInches = value


func _on_width_selection_mouse_entered():
	global.hoveringGUI = true


func _on_length_selection_mouse_entered():
	global.hoveringGUI = true


func _on_height_selection_mouse_entered():
	global.hoveringGUI = true


func _on_snapped_selection_mouse_entered():
	global.hoveringGUI = true


func _on_reset_colors_pressed():
	global.resetColors = true


func _on_check_button_pressed():
	global.resetColors = !global.resetColors


func _on_check_button_mouse_entered():
	global.hoveringGUI = true


func _on_speed_slider_mouse_entered():
	global.hoveringGUI = true


func _on_speed_slider_mouse_exited():
	global.hoveringGUI = false

func _on_speed_slider_value_changed(value):
	global.speedSlider = value


func _on_fold_in_button_pressed():
	foldedIn = !foldedIn
	if foldedIn:
		animationPlayer.play("foldAway")
	else:
		animationPlayer.play_backwards("foldAway")


func _on_fold_in_button_mouse_entered():
	global.hoveringGUI = true


func _on_fold_in_button_mouse_exited():
	global.hoveringGUI = false



func _on_export_rr_button_mouse_entered():
	global.hoveringGUI = true


func _on_export_rr_button_mouse_exited():
	global.hoveringGUI = false


func _on_check_button_2_mouse_entered():
	global.hoveringGUI = true


func _on_check_button_2_mouse_exited():
	global.hoveringGUI = false
