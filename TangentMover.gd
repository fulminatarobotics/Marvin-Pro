extends Node3D

var startRotatingRed = false
var startRotatingBlack = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.top_level = true
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("ui_mouse_right") or Input.is_action_just_pressed("ui_mouse_left")) and global.currentObj == find_child("Colision1") and !global.hoveringGUI:
		ControlZ.resetRedo()
		ControlZ.actions.append(["posChanged",get_parent().position.x,get_parent().position.z,get_parent().rotation.y,self.rotation.y,global.botOrder.find(get_parent())])
		startRotatingRed = true
	if startRotatingRed:
		var tempPos = global.currentMousePos
		tempPos.y = self.global_position.y
		self.look_at(Vector3(tempPos), Vector3(0,1,0))
		if Input.is_action_pressed("ui_shift"):
			self.rotation.y = snapped(self.rotation.y,PI/8)
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		startRotatingRed = false
	if (Input.is_action_just_pressed("ui_mouse_right") or Input.is_action_just_pressed("ui_mouse_left")) and global.currentObj == find_child("Colision2") and !global.hoveringGUI:
		ControlZ.resetRedo()
		ControlZ.actions.append(["posChanged",get_parent().position.x,get_parent().position.z,get_parent().rotation.y,self.rotation.y,global.botOrder.find(get_parent())])
		startRotatingBlack = true
	if startRotatingBlack:
		var tempPos = global.currentMousePos
		tempPos.y = self.global_position.y
		self.look_at(Vector3(tempPos), Vector3(0,1,0))
		self.rotation.y = self.rotation.y + PI
		if Input.is_action_pressed("ui_shift"):
			self.rotation.y = snapped(self.rotation.y,PI/8)
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		startRotatingBlack = false
		
	if global.isPreviewing:
		find_child("Cylinder").mesh.surface_get_material(0).transparency = 1
		find_child("Cylinder").mesh.surface_get_material(0).albedo_color.a = 0.1
		find_child("Sphere").mesh.surface_get_material(0).transparency = 1
		find_child("Sphere").mesh.surface_get_material(0).albedo_color.a = 0.1
		find_child("Sphere_001").mesh.surface_get_material(0).transparency = 1
		find_child("Sphere_001").mesh.surface_get_material(0).albedo_color.a = 0.1
	else:
		find_child("Cylinder").mesh.surface_get_material(0).transparency = 0
		find_child("Sphere").mesh.surface_get_material(0).transparency = 0
		find_child("Sphere_001").mesh.surface_get_material(0).transparency = 0
