extends Label3D

func _ready():
	self.rotation = Vector3(-90,0,0)

func _process(delta):
	self.position = get_parent().position
	if get_parent().find_child("Testing").find_child("temp").visible:
		self.position.y = get_parent().scale.y + 0.6
	elif get_parent().find_child("Testing").find_child("temp2").visible:
		self.position.y = get_parent().scale.y + 0.45
	else:
		self.position.y = get_parent().scale.y
	#self.global_rotation.x = deg_to_rad(-90)
	if global.camPerspective == true:
		look_at(global.camera.global_position)
		self.rotation.x += deg_to_rad(180)
		self.rotation.z += deg_to_rad(180)
	else:
		self.rotation = Vector3(deg_to_rad(-90),0,0)
	self.text = str(global.botOrder.find(get_parent())+1)
	
