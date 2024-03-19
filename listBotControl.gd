extends Button

@onready var backBut = $backBut
@onready var forwardBut = $forwardBut
@onready var deleteBut = $deleteBut
@onready var xCord = $xCord
@onready var yCord = $yCord
@onready var tan = $tan
@onready var heading = $heading

@onready var animationPlrSeek = $"../AnimationPlayerSeek"
@onready var animationPlrButton = $"../AnimationPlayerButton"

@export var gradient: Gradient

var parent
var connectedBot
var connectedBotOutline
var outlineLerpT = 0
var timeSinceStart = 0
var speedOfOutline = 0.05

func _ready():
	animationPlrButton.play("RESETLeft")
	backBut.visible = false
	forwardBut.visible = false
	xCord.visible = false
	yCord.visible = false
	tan.visible = false
	heading.visible = false
	parent = get_parent()
	connectedBot = get_node(parent.get_meta("conntectedBot"))
	connectedBot.setConnection(self)
	connectedBotOutline = connectedBot.find_child("Outline")
	var unique_mat = connectedBotOutline.get_active_material(0).duplicate()
	connectedBotOutline.set_surface_override_material(0, unique_mat)
	visibleButtons(false)
	
	backBut.set_material(backBut.get_material().duplicate(true))
	forwardBut.set_material(backBut.get_material().duplicate(true))
	

func _on_pressed():
	var eventPos = get_viewport().get_mouse_position()
	if !xCord.visible or not _is_pos_in(eventPos,xCord) and not _is_pos_in(eventPos,yCord) and not _is_pos_in(eventPos,tan) and not _is_pos_in(eventPos,heading):
		visibleButtons(!deleteBut.visible)

func visibleButtons(areVisible):
	deleteBut.visible = areVisible
	if areVisible == true:
		backBut.visible = areVisible
		forwardBut.visible = areVisible
		xCord.visible = areVisible
		yCord.visible = areVisible
		tan.visible = areVisible
		heading.visible = areVisible
		animationPlrSeek.play("buttonSlideOut")
	else:
		animationPlrSeek.play("buttonSlideIn")
	
	
func _is_pos_in(checkpos:Vector2, gr):
	gr = gr.get_global_rect()
	return checkpos.x>=gr.position.x and checkpos.y>=gr.position.y and checkpos.x<gr.end.x and checkpos.y<gr.end.y

func _input(event):
	if (event is InputEventMouseButton and xCord.visible and not _is_pos_in(event.position,self) and not _is_pos_in(event.position,xCord) and not _is_pos_in(event.position,yCord) and not _is_pos_in(event.position,tan) and not _is_pos_in(event.position,heading) and (Input.is_action_just_released("ui_mouse_left") or Input.is_action_just_released("ui_mouse_right"))) or Input.is_action_just_pressed("ui_esc"):
		self.visible = false
		self.visible = true
		visibleButtons(false)

func _on_back_but_pressed():
	animationPlrButton.play("moveButtonLeft")
	var otherBot = get_node(global.botOrder[global.botOrder.find(connectedBot)-1].get_meta("connectedListBot"))
	if !otherBot.find_child("AnimationPlayerButton").is_playing():
		otherBot.get_child(0)._on_forward_but_pressed()
	
func _on_forward_but_pressed():
	animationPlrButton.play("moveButtonRight")
	var otherBot = get_node(global.botOrder[global.botOrder.find(connectedBot)+1].get_meta("connectedListBot"))
	if !otherBot.find_child("AnimationPlayerButton").is_playing():
		otherBot.get_child(0)._on_back_but_pressed()
	

func _on_delete_but_pressed():
	var botPos = connectedBot.position
	ControlZ.actions.append(["Deleted",botPos.x,botPos.z,connectedBot.rotation.y, connectedBot.find_child("TangentMover").rotation.y, global.botOrder.find(connectedBot),connectedBot.returnOrder()])
	ControlZ.resetRedo()
	global.botOrder.remove_at(global.botOrder.find(connectedBot))
	connectedBot.queue_free()
	get_parent().queue_free()

func _process(delta):
	
	if global.botOrder.find(connectedBot) == -1:
		connectedBot.queue_free()
		get_parent().queue_free()
	
	if global.usingTextEdit == null:
		xCord.text = str(-snapped(connectedBot.position.z*12,0.001))
		yCord.text = str(-snapped(connectedBot.position.x*12,0.001))
		tan.text = str(snapped(rad_to_deg(connectedBot.find_child("TangentMover").rotation.y),0.001))
		heading.text = str(snapped(rad_to_deg(connectedBot.rotation.y),0.001))
	elif global.usingTextEdit.get_parent() != self:
		xCord.text = str(-snapped(connectedBot.position.z*12,0.001))
		yCord.text = str(-snapped(connectedBot.position.x*12,0.001))
		tan.text = str(snapped(rad_to_deg(connectedBot.find_child("TangentMover").rotation.y),0.001))
		heading.text = str(snapped(rad_to_deg(connectedBot.rotation.y),0.001))
	
	var new_stylebox_normal = self.get_theme_stylebox("normal").duplicate()
	new_stylebox_normal.bg_color = connectedBot.mesh.material.albedo_color
	
	var new_stylebox_hover = self.get_theme_stylebox("normal").duplicate()
	new_stylebox_hover.bg_color = connectedBot.mesh.material.albedo_color - Color(0.2,0.2,0.2,0)
	
	self.add_theme_stylebox_override("normal", new_stylebox_normal)
	self.add_theme_stylebox_override("hover", new_stylebox_hover)
	self.add_theme_stylebox_override("pressed", new_stylebox_normal)
	self.add_theme_stylebox_override("disabled", new_stylebox_normal)
	self.add_theme_stylebox_override("focus", new_stylebox_normal)
	
	parent.get_parent().move_child(parent, global.botOrder.find(connectedBot))
	var currentListPos = global.botOrder.find(connectedBot)
	if currentListPos == 0:
		backBut.visible = false
	if currentListPos == len(global.botOrder)-1:
		forwardBut.visible = false
		
	timeSinceStart +=delta
	connectedBotOutline.get_active_material(0).albedo_color = gradient.sample((timeSinceStart*speedOfOutline - int(timeSinceStart * speedOfOutline)))
	if outlineLerpT <= 1 and (!xCord.visible or animationPlrSeek.current_animation == "buttonSlideIn"):
		outlineLerpT -= delta*5
		outlineLerpT = max(0,outlineLerpT)
		connectedBotOutline.get_active_material(0).albedo_color.a = outlineLerpT
	elif outlineLerpT >= 0 and xCord.visible:
		outlineLerpT += delta *5
		outlineLerpT = min(1,outlineLerpT)
		connectedBotOutline.get_active_material(0).albedo_color.a = outlineLerpT
func _on_x_cord_pressed():
	newTextInput(xCord)
	
func _on_y_cord_pressed():
	newTextInput(yCord)
	
func _on_tan_pressed():
	newTextInput(tan)

func _on_heading_pressed():
	newTextInput(heading)

func newTextInput(obj):
	global.textInput.visible = true
	global.textInput.grab_focus()
	global.textInput.text = obj.text
	global.usingTextEdit = obj
	global.textInput.select_all()
	
func updateValues():
	if global.usingTextEdit == xCord:
		if float(xCord.text) != 0 or xCord.text == "0":
			ControlZ.resetRedo()
			ControlZ.actions.append(["posChanged",connectedBot.position.x,connectedBot.position.z,connectedBot.rotation.y,connectedBot.find_child("TangentMover").rotation.y,global.botOrder.find(connectedBot)])
			connectedBot.position.z = -float(xCord.text)/12.0
	if global.usingTextEdit == yCord:
		if float(yCord.text) != 0 or yCord.text == "0":
			ControlZ.resetRedo()
			ControlZ.actions.append(["posChanged",connectedBot.position.x,connectedBot.position.z,connectedBot.rotation.y,connectedBot.find_child("TangentMover").rotation.y,global.botOrder.find(connectedBot)])
			connectedBot.position.x = -float(yCord.text)/12.0
	if global.usingTextEdit == tan:
		if float(tan.text) != 0 or tan.text == "0":
			ControlZ.resetRedo()
			ControlZ.actions.append(["posChanged",connectedBot.position.x,connectedBot.position.z,connectedBot.rotation.y,connectedBot.find_child("TangentMover").rotation.y,global.botOrder.find(connectedBot)])
			connectedBot.find_child("TangentMover").rotation.y = deg_to_rad(float(tan.text))
	if global.usingTextEdit == heading:
		if float(heading.text) != 0 or heading.text == "0":
			ControlZ.resetRedo()
			ControlZ.actions.append(["posChanged",connectedBot.position.x,connectedBot.position.z,connectedBot.rotation.y,connectedBot.find_child("TangentMover").rotation.y,global.botOrder.find(connectedBot)])
			connectedBot.rotation.y = deg_to_rad(float(heading.text))
	global.usingTextEdit = null

func updateHues(hue):
	forwardBut.material.set_shader_parameter("Shift_Hue", 0.83 * hue)
	backBut.material.set_shader_parameter("Shift_Hue", 0.83 * hue)
	

func _on_animation_player_button_animation_finished(anim_name):
	if anim_name == "moveButtonRight":
		animationPlrButton.play("RESET")
	if anim_name == "moveButtonLeft":
		animationPlrButton.play("RESETLeft")
	if anim_name == "RESET":
		var tempPos = global.botOrder.find(connectedBot)
		ControlZ.resetRedo()
		ControlZ.actions.append(["movedOrder",tempPos])
		global.botOrder.insert(tempPos+1, global.botOrder.pop_at(tempPos))
		ControlZ.actions[len(ControlZ.actions)-1].append(global.botOrder.find(connectedBot))
		
