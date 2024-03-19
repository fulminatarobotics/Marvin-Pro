extends MeshInstance3D

var orderCreated

@export var gradient: Gradient
var newMat;
var firstClick = true
var startRotating = false
var startMoving = false
var connectedListItem

var listBotScene = load("res://list_bot.tscn")
@onready var listBotContainer = $"/root/Node3D/settings/CanvasLayer/ScrollContainer/botListContainer"

# Called when the node enters the scene tree for the first time.
func _ready():
	orderCreated = global.numBotsCreated
	global.numBotsCreated += 1
	self.mesh.material.albedo_color = gradient.sample(1.0/len(global.botOrder))
	var instance = listBotScene.instantiate()
	instance.set_meta("conntectedBot", get_path())
	listBotContainer.add_child(instance)
	set_meta("connectedListBot",instance.get_path())

func _process(delta):
	
	if global.invisBots:
		self.visible = false
	else:
		self.visible = true
	
	self.scale = global.botDimentions/12.0
	self.position.y = global.botDimentions.y/24.0
	
	var selfPosInList = global.botOrder.find(self)
	if selfPosInList != -1:
		if selfPosInList != 0:
			var dist = self.global_position.distance_to(global.botOrder[selfPosInList-1].global_position)
			self.find_child("TangentMover").find_child("ForwardTan").position.z = (1)*dist*1.25
		if selfPosInList != len(global.botOrder)-1:
			var dist = self.global_position.distance_to(global.botOrder[selfPosInList+1].global_position)
			self.find_child("TangentMover").find_child("BackTan").position.z = -(1)*dist*1.25
		
		if len(global.botOrder) > 1:
			self.mesh.material.albedo_color = gradient.sample((1.0/(global.numBotsCreated-1))*orderCreated)
			if connectedListItem != null:
				connectedListItem.updateHues((1.0/(global.numBotsCreated-1))*orderCreated)
		else:
			self.mesh.material.albedo_color = gradient.sample(0)
			if connectedListItem != null:
				connectedListItem.updateHues(0)
		if global.resetColors:
			orderCreated = global.botOrder.find(self)
			
		if global.isPreviewing:
			self.mesh.material.albedo_color.a = 0.2
			find_child("Front").mesh.material.transparency = 1
			find_child("Front").mesh.material.albedo_color.a = 0.2
		else:
			self.mesh.material.albedo_color.a = 1
			find_child("Front").mesh.material.transparency = 0
			find_child("Front").mesh.material.albedo_color.a = 1
			
		if firstClick or startRotating:
			var tempPos = global.currentMousePos
			tempPos.y = self.position.y
			self.look_at(Vector3(tempPos), Vector3(0,1,0))
			if Input.is_action_pressed("ui_shift"):
				self.rotation.y = snapped(self.rotation.y,PI/8)
		if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			firstClick = false
			startMoving = false
		if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			startRotating = false
		if global.currentObj != null and is_instance_valid(global.currentObj):
			if Input.is_action_just_pressed("ui_mouse_right") and global.currentObj.get_parent() == self and !global.hoveringGUI:
				ControlZ.actions.append(["posChanged",self.position.x,self.position.z,self.rotation.y,find_child("TangentMover").rotation.y,global.botOrder.find(self)])
				startRotating = true
				ControlZ.resetRedo()
			if Input.is_action_just_pressed("ui_mouse_left") and global.currentObj.get_parent() == self and !global.hoveringGUI:
				ControlZ.actions.append(["posChanged",self.position.x,self.position.z,self.rotation.y,find_child("TangentMover").rotation.y,global.botOrder.find(self)])
				startMoving = true
				ControlZ.resetRedo()
		if startMoving:
			self.get_child(0).get_child(0).disabled = true
			var tempPos = global.currentMousePos
			tempPos.y = self.position.y
			self.position = tempPos
			if Input.is_action_pressed("ui_shift"):
				self.position.x = snapped(self.position.x,global.snappedInches/12.0)
				self.position.z = snapped(self.position.z,global.snappedInches/12.0)
		else:
			self.get_child(0).get_child(0).disabled = false
		
func setConnection(connectedList):
	connectedListItem = connectedList
	
func stopFirstClick():
	firstClick = false

func returnOrder():
	return orderCreated
func setOrderCreated(order):
	orderCreated = order
